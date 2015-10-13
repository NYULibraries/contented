---
title: Ask a Librarian
date: 2015-10-08 13:36:00 Z
permalink: "/services/forms/ask"
---

<div class="wrap content has-sidebar">
  <div class="block block--body" data-swiftype-index="true">
    <link rel="stylesheet" type="text/css" href="/assets/css/style-guide.css" />
    <div class="style-guide-content--questionpoint-forms">
      <form action="http://www.questionpoint.org/crs/servlet/org.oclc.ask.AskPatronQuestion" method="post" name="entryform1" onsubmit="return checkIt(this)">
        <div class="required">Required Field<span>*</span></div>
        <fieldset>
          <input type="hidden" name="language" value="1" />
          <input type="hidden" name="library" value="11986" />
          <input type="hidden" name="label3" value="Location">
          <input type="hidden" name="field3" id="field3" value="FROM GENERAL NYU LIBRARIES AAL FORM">
          <input type="hidden" name="label1" value="NetID" />
          <input type="hidden" name="label4" value="Status" />
          <input type="hidden" name="label7" value="Subject" />
          <input type="hidden" name="label6" value="Global site" />
        </fieldset>
        <fieldset class="legend">
          <legend>Please Complete the Form Below</legend>
          <div>
            <label for="name" class="required">Name<span>*</span><br /></label>
            <input type="text" id="name" name="name" maxlength="255" />
          </div>
          <div>
            <label for="email" class="required">E-mail Address<span>*</span><br />
            <em>For best results, <a href="http://library.nyu.edu/ask/askapolicy.html#alias" target="_blank">use your outgoing email address or alias</a></em><br /></label>
            <input type="text" id="email" name="email" />
          </div>
          <div>
            <label for="question" class="required">Question<span>*</span><br /></label>
            <textarea id="question" name="question" rows="5"></textarea>
          </div>
          <div>
            <label for="field1" class="required">Net ID<span>*</span><br /></label>
            <input type="text" id="field1" name="field1" />
          </div>
          <div>
            <label for="field4">Status</label><br />
            <select id="field4" name="field4">
              <option value="0" selected="selected">Select one</option>
              <option value="Undergraduate">Undergraduate Student</option>
              <option value="Graduate">Graduate Student</option>
              <option value="Faculty">Faculty</option>
              <option value="Admin/Staff">Administrator/Staff</option>
              <option value="Research/Teaching Assistant">Research/Teaching Assistant</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div>
            <label for="field7">Subject</label><br />
            <select id="field7" name="field7">
              <option value="0" selected="selected">Select One</option>
              <option value="Arts and Humanities">Arts and Humanities</option>
              <option value="Business">Business</option>
              <option value="Engineering">Engineering</option>
              <option value="Government Information">Government Information</option>
              <option value="Health Sciences">Health Sciences</option>
              <option value="Sciences">Sciences</option>
              <option value="Social Sciences">Social Sciences</option>
              <option value="IFA">IFA</option>
              <option value="NYU-Poly">Bern Dibner</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div>
            <label for="field6">Library or Global site</label><br />
            <select id="field6" name="field6">
              <option value="0" selected="selected">Select one</option>
              <option value="NYC">NYC</option>
              <option value="Abu Dhabi">Abu Dhabi</option>
              <option value="Accra">Accra</option>
              <option value="Berlin">Berlin</option>
              <option value="Bern Dibner">Bern Dibner Library: NYU Polytechnic School of Engineering</option>
              <option value="Buenos Aires">Buenos Aires</option>
              <option value="Florence">Florence</option>
              <option value="London">London</option>
              <option value="Madrid">Madrid</option>
              <option value="Paris">Paris</option>
              <option value="Prague">Prague</option>
              <option value="Shanghai">Shanghai</option>
              <option value="Sydney">Sydney</option>
              <option value="Tel Aviv">Tel Aviv</option>
              <option value="DC">Washington DC</option>
              <option value="Other">Other</option>
            </select>
          </div>
        </fieldset>
        <fieldset class="submit">
          <button class="button" value="Submit" onclick="submitForm(document.entryform1)" />Submit
        </fieldset>
        </form>
    </div>
  </div>
</div>