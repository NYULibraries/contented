---
date: 2015-10-13 15:10:00 Z
permalink: "/services/forms/test"
title: test
---

<form action="http://www.questionpoint.org/crs/servlet/org.oclc.ask.AskPatronQuestion" method="post" name="entryform1" onsubmit="return checkIt(this)">
  <div class="required">Required Field<span>*</span></div>
  <fieldset><input type="hidden" name="source" value="3"> <!-- Begin language hidden input field. --> <!-- If this form will be in a language other than English, replace the value attribute "1" with the appropriate value for your language, as described in http://questionpoint.org/web/members/addingquestionform.html. --> <input type="hidden" name="language" value="1"> <!-- End language hidden input field --> <!-- Begin library hidden input field --> <!-- Replace the value attribute "1" with your library's Ask a Librarian institution ID, supplied by OCLC, in the library hidden input field --> <input type="hidden" name="library" value="11986"> <input type="hidden" name="label3" value="Location"> <input id="field3" type="hidden" name="field3" value="CONSULTATION REQUEST - ASSIGN TO APPROPRIATE SELECTOR or PAULA FEID IF FRESHMAN/SOPHOMORE"> <input type="hidden" name="label17" value="Schedule Requests"> <input type="hidden" name="label1" value="NetID"> <input type="hidden" name="label4" value="Status"> <input type="hidden" name="label7" value="Subject"> <input type="hidden" name="label6" value="Global Site"> <!-- End library hidden input field --></fieldset><fieldset class="legend"><legend>Please complete the form below. Your answers will assist us in finding the right subject specialist librarian to help you.</legend>
  <div><label class="text required" for="name"> Name:<span>*</span><br> </label> <input id="name" class="text" type="text" name="name" maxlength="255"></div>
  <div>
  <p><label class="text required" for="email">E-mail Address:<span>*<br> </span></label> <input id="email" class="text" type="text" name="email"></p>
  </div>
  <div>
  <p><label class="text required" for="field1">Net ID<span>:*<br> </span></label> <input id="field1" class="text" type="text" name="field1"></p>
  </div>
  <div><label for="alternate_editions01" class="text" classname="text">Alternate editions acceptable</label><input id="alternate_editions01.Yes" name="alternate_editions01" type="radio" value="Yes" class="radio" classname="radio">Yes<input id="alternate_editions01.No" name="alternate_editions01" type="radio" value="No" class="radio" classname="radio">No</div>
  <div>I will supply <input id="personal_copies01" name="personal_copies01" type="text" class="smalltext" classname="smalltext"> personal copies</div>
  <div>
  <p><label class="text required" for="question">Describe the topic you are researching. Please be as specific as possible. What kind of information are you looking for? What steps have you taken so far in researching this topic?<span>*</span></label> <textarea id="question" class="text" name="question" rows="5"></textarea></p>
  <p><label for="availability">Please tell us 3 dates and times you are available to meet. The librarian in your subject area will contact you to finalize your meeting details.</label> Please note that the librarian may also choose to respond to your help request via email rather than an in-person meeting. <br> <input id="field17" class="text" type="text" name="field17"></p>
  </div>
  <div>
  <p><label class="text required" for="field4">Status:<span>*<br> </span></label><select id="field4" name="field4">
  <option selected="selected" value="0">Select one</option>
  <option value="Freshman/Sophomore">Freshman/Sophomore</option>
  <option value="Junior/Senior">Junior/Senior</option>
  <option value="Graduate">Graduate Student</option>
  <option value="Faculty">Faculty</option>
  <option value="Admin/Staff">Administrator/Staff</option>
  <option value="Research/Teaching Assistant">Research/Teaching Assistant</option>
  <option value="Other">Other</option>
  </select></p>
  </div>
  <div>
  <p><label class="text" for="field7">Broad Subject Area of your request:<br> </label><select id="field7" name="field7">
  <option selected="selected" value="0">Select One</option>
  <option value="Arts and Humanities">Arts and Humanities</option>
  <option value="Business">Business</option>

    <option value="Engineering">Engineering</option>

  <option value="Government Information">Government Information</option>
  <option value="Health Sciences">Health Sciences</option>
  <option value="Sciences">Sciences</option>
  <option value="Social Sciences">Social Sciences</option>
  <option value="Other">Other/Not sure</option>
  </select></p>
  </div>
  <!-- Use this section to include a field for: name="label6" value="Global Site" -->
  <div>
  <p><label class="text" for="field6">Library:<span><br> </span></label><select id="field6" name="field6">
  <option selected="selected" value="0">Select one</option>
  <option value="NYC">NYC</option>
  <option value="Abu Dhabi">Abu Dhabi</option>
  <option value="Berlin">Berlin</option>
    <option value="BernDibner"> Bern Dibner Library: NYU Polytechnic School of Engineering</option>

  <option value="Buenos Aires">Buenos Aires</option>
  <option value="Florence">Florence</option>
  <option value="Ghana">Ghana</option>
  <option value="London">London</option>
  <option value="Madrid">Madrid</option>
  <option value="Paris">Paris</option>
  <option value="Prague">Prague</option>
  <option value="Shanghai">Shanghai</option>
  <option value="Other">Other</option>
  </select></p>
  </div>
  <!-- End Global site section --></fieldset><fieldset class="submit"><input onclick="submitForm(document.entryform1)" type="image" value="submit" src="/images/submit_button.gif"></fieldset><div id="broken_form"><input class="text" id="dqwwaccdf8924" name="dqwwaccdf8924" type="text"></div>
</form>