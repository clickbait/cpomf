script type="text/javascript" src="https://www.google.com/recaptcha/api.js"
main.page.single
  .wrapper
    h2= file.not_nil!.original_filename
    .content Be cautious when downloading this file, this is the internet, bad people exist; so you should use your anti-virus before running any potentially malicious content.
   	  br
		  form#download method="post"
		    == "<div class=\"g-recaptcha\" data-sitekey=\"6Ld8BAwUAAAAAFe6lY0LSGmrAaLupbtpdjx3W_qC\" data-theme=\"dark\"></div>"
		    #button
		      button type="submit" Download File
			hr
			== "Found a virus? You can report it by sending an email to <a href=\"mailto:abuse@nya.is\">abuse@nya.is</a>"
