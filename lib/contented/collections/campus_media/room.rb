require 'liquid'
require 'ostruct'
require 'httparty'
require 'active_support'
require 'pry'

module Contented
  module Collections
    module CampusMedia
      class Room
        FILE_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__))) + '/../../..'
        GIT_URL = "https://raw.githubusercontent.com/NYULibraries/campusmedia-fillins/master/".freeze

        ATTRIBUTES_BY_SOURCE = {
          room: [:id, :building_id, :technology],
          padding: [
            :title, :published, :capacity, :links,
            :image, :departments, :floor, :buttons,
            :policies, :description, :type, :keywords,
            :help, :access, :body
          ],
          building: [:address],
          technology: [:features, :equipment],
        }.freeze

        # concatenate all the attribute arrays
        ATTRIBUTES = ATTRIBUTES_BY_SOURCE.values.flatten.freeze

        attr_reader :raw, :save_location

        def self.template_file
          File.read("#{FILE_ROOT}/lib/contented/templates/campusmedia/room.markdown")
        end

        def self.get_config(key)
          res = HTTParty.get("#{GIT_URL}#{key}.yml")
          YAML.safe_load(res.body)
            .deep_symbolize_keys
        end

        def self.rooms_config
          @rooms_config ||= Room.get_config(:rooms).freeze
        end

        def self.buildings_config
          @buildings_config ||= Room.get_config(:buildings).freeze
        end

        def self.technology_config
          @technology_config ||= Room.get_config(:technology).freeze
        end

        def self.equipment
          @equipment ||= (
            technology_config.reduce({}) do |dict, (id, props)|
              is_equipment = props[:type] === "equipment"
              is_equipment ? dict.merge!(id => props) : dict
            end
          ).freeze
        end

        def self.features
          @features ||= (
            technology_config.reduce({}) do |dict, (id, props)|
              is_feature = props[:type] === 'feature'
              is_feature ? dict.merge!(id => props) : dict
            end
          ).freeze
        end

        def self.defaults
          default_vals = {
            links: {},
            policies: {},
            buttons: {},
            keywords: [],
            help: {
              text: nil,
              phone: nil,
              email: nil,
            },
          }

          @defaults ||= (
            Room.rooms_config[:default].reduce({}) do |config, (k, v)|
              v ? config.merge!(k => v) : config.merge!(k => default_vals[k])
            end
          ).freeze
        end

        def self.merge_defaults!(attributes)
          # key-value merges
          [:links, :policies, :buttons].reduce(attributes) do |attrs, k|
            merged = defaults[k].merge(attrs[k] || {})
            attrs.merge!(k => merged)
            attrs
          end
          # array merge
          [:keywords].reduce(attributes) do |attrs, k|
            merged = defaults[k].concat(attrs[k] || []).uniq
            attrs.merge!(k => merged)
          end
          # deeper hash merges
          [:help].reduce(attributes) do |attrs, k|
            attrs[k] ||= {}
            merged = defaults[k].merge(attrs[k] || {})
            attrs[k].merge!(merged)
          end
          attributes
        end

        def initialize(raw_data, save_location)
          @raw = raw_data.deep_symbolize_keys
          @save_location = save_location
          id = raw[:id].to_sym

          attributes = {}
          attributes.merge!(raw.slice(*ATTRIBUTES_BY_SOURCE[:room]))
          attributes.merge!(Room.rooms_config[id].slice(*ATTRIBUTES_BY_SOURCE[:padding]))
          Room.merge_defaults!(attributes)

          @room_props = OpenStruct.new(attributes)
        end

        def filename
          title.
            downcase.
            gsub(' ', '_').
            squeeze('_').
            chomp('_')
        end

        def address
          Room.buildings_config.dig(building_id.to_sym, :address)
        end

        def equipment
          # returns a dictionary { label => description, ... }
          technology.reduce({}) do |dict, item|
            item_data = Room.equipment[item.to_sym]
            if item_data
              label = item_data[:label]
              description = item_data[:description]
              dict.merge!(label => description)
            end
            dict
          end
        end

        def features
          # returns a list of technology features [label1, label2, ...]
          technology.reduce([]) do |list, f|
            feature = Room.features[f.to_sym]
            feature ? list.push(feature[:label]) : list
          end
        end

        def method_missing(meth, *args)
          if ATTRIBUTES.include?(meth)
            @room_props.send(meth)
          else
            super(meth, *args)
          end
        end

        def save_as_markdown!
          File.write("#{save_location}/#{filename}.markdown", to_markdown)
        end

        def to_markdown
          liquid_hash = ATTRIBUTES.reduce({}) do |hash, attribute|
            val = send(attribute)
            val = val.deep_stringify_keys if val.is_a? Hash
            hash.merge!(attribute.to_s => val)
          end

          template = Liquid::Template.parse(Room.template_file)
          rendered = template.render(liquid_hash, strict_variables: true)
          p template.errors
          rendered
        end
      end
    end
  end
end
