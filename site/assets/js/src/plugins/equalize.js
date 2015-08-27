var equalizeBlockHeights, equalizeRowHeight;

equalizeRowHeight = function(row) {
  var block, j, len, ref, results, rowHeight;
  rowHeight = Math.max.apply(null, row['heights']);
  ref = row['elements'];
  results = [];

  for (j = 0, len = ref.length; j < len; j++) {
    block = ref[j];
    block.style.minHeight = rowHeight + "px";
    results.push(block.classList.add('is-equalized'));
  }
};

equalizeBlockHeights = function(elements, clearHeights) {
  var block, elements, i, j, len, results, row, rowTop;
  if (!elements.length) return;

  row = {
    'elements': [],
    'heights': []
  };

  rowTop = elements[0].offsetTop;
  results = [];

  // Group blocks into rows and save each block's height
  for (i = j = 0, len = elements.length; j < len; i = ++j) {
    block = elements[i];

    // Start a new row if this block is the first item of a new row
    if (block.offsetTop !== rowTop && i !== 0) {
      // Equalize the previous row so we can properly calculate
      // the offsetTop of the blocks below it.
      equalizeRowHeight(row);
      row = {
        'elements': [],
        'heights': []
      };
      rowTop = block.offsetTop;
    }

    if (clearHeights)
      block.style.minHeight = 0;

    row['elements'].push(block);
    results.push(row['heights'].push(block.offsetHeight));
  }

  equalizeRowHeight(row);
};