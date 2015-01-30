# ASpace-plugins

A test space for local ArchivesSpace plugins.


### public/views/records/resource.html.erb 

For some unexplained reason, some fields do not appear in the public view unless
    Finding Aid Status == "completed" .
    
See: [[Archivesspace_Users_Group] Fields not appearing in public view
](http://lyralists.lyrasis.org/pipermail/archivesspace_users_group/2015-January/001024.html)

This template is just a copy of the standard view with the conditional changed to "if true" . 


### backend/model/my_ead_converter.rb

I found [moma-ead-converter](https://github.com/quoideneuf/moma-ead-importer) as a template for how to add a new converter via ASpace plugins. 

	class MyEadConverter < EADConverter

		def self.import_types(show_hidden = false)
	    	[
	     		{
	       		:name => "my_ead_xml",
	       		:description => "Import EAD records from an XML file MY WAY!"
	     		}
	    	]
    	end

		def self.instance_for(type, input_file)
	    	if type == "my_ead_xml"
	      		self.new(input_file)
	    	else
	      		nil
	    	end
		end
	
		def self.profile
	   		"Convert EAD To ArchivesSpace JSONModel records MY WAY!"
		end

	end

This seems to be a minimal starting template. 
It needs an entry in the locales file to keep from getting no-translation errors in the menu & display:

####frontend/locales/en.yml

	en:
	    job:
	        import_type_my_ead_xml : MyEAD`