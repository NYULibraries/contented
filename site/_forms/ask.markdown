---
title: Ask a Librarian
date: 2015-10-08 13:36:00 Z
permalink: "/services/forms/ask"
---

<header class="banner banner--page">
  <div  class="wrap">
    <div class="banner__inner">
      <h1 class="heading heading--page">Ask a Librarian</h1>
    </div>
  </div>
</header>
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
            <textarea id="question" name="question" rows="5">