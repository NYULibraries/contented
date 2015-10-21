---
date: 2015-10-15 15:47:47 Z
permalink: "/services/forms/feedback"
title: Suggestions and Comments
---

<form action="http://www.questionpoint.org/crs/servlet/org.oclc.ask.AskPatronQuestion" method="POST" onsubmit="return checkIt(this)" name="entryform1">    
  <input type="HIDDEN" name="source" value="3">
  <input type="HIDDEN" name="language" value="1">
  <!-- "1" = English for form's language -->
  <input type="HIDDEN" name="library" value="11986">
  <!-- library's institution code -->
  <input type="HIDDEN" name="email" value="">
  <!-- real email; passed to OCLC -->
  <!-- custom labels -->
  <input type="HIDDEN" name="label6" value="Location">
  <input type="HIDDEN" name="field3" value="FROM GENERAL COMMENT/SUGGESTION PAGE">
  <input type="HIDDEN" name="label7" value="Name">
  <!-- actual name  -->
  <div>What comments or suggestions do you have for improving the library?</div>
  <div>Enter your comments below, and be sure to leave an email and name if you would like to be contacted </div>
  <fieldset> 
    <textarea id="QUESTION" name="question" rows="8" cols="50"></textarea>
  </fieldset>
  <fieldset>
    <label for="FIELD7" accesskey="N">Name:</label>
    <input id="FIELD7" type="TEXT" name="field7" value="" size="32" maxlength="100" />
    <label for="EMAIL" accesskey="E">Email:</label>
    <input type="TEXT" name="usremail" value="" size="32" maxlength="100" />
  </fieldset>
  <fieldset class="submit">
    <button class="button" value="Submit" onclick="submitForm(document.entryform1)" />Submit
  </fieldset>
</form>