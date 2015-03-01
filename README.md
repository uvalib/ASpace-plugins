# ASpace-plugins

A test space for local ArchivesSpace plugins.
Some of these could be split into separate repos and projects, but for now 
they are together for the ease of being able to clone this repo into 
archivesspace/plugins/local .


The directory structure in place in the ASpace distributions `plugins/local` directory seems to provide a template for which directories are automatically loaded by ArchivesSpace. 

See [LoadingPlugins](LoadingPlugins.md) for more details. 

---
### public/views/records/resource.html.erb 

For some unexplained reason, some fields do not appear in the public view unless
    Finding Aid Status == "completed" .
    
See: [[Archivesspace_Users_Group] Fields not appearing in public view
](http://lyralists.lyrasis.org/pipermail/archivesspace_users_group/2015-January/001024.html)

This template is just a copy of the standard view with the conditional changed to "if true" . 

---
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
	        

---
### backend/model/ead_serializer.rb

replacement EAD serializer. 

*v1*  Tag image_url with @id="logostmt" so it can be identified by xsl stylesheets. 
[upstream push request](https://github.com/archivesspace/archivesspace/pull/132)

	           if data.repo.image_url
	-            xml.p {
	+            xml.p ( { "id" => "logostmt" } ) {
	               xml.extref ({"xlink:href" => data.repo.image_url,
	                           "xlink:actuate" => "onLoad",
	                           "xlink:show" => "embed",


*v2* Add URL links to `<address>`

	@@ -633,6 +633,16 @@ class EADSerializer < ASpaceExport::Serializer
	               data.addresslines.each do |line|
	                 xml.addressline { sanitize_mixed_content( line, xml, fragments) }  
	               end
	+              if data.repo.url 
	+               xml.addressline ( "URL: " ) { 
	+                 xml.extptr ( { 
	+                                               "xlink:href" => data.repo.url,
	+                                               "xlink:title" => data.repo.url,
	+                                               "xlink:type" => "simple",
	+                                               "xlink:show" => "new"
	+                                               } )
	+                }
	+              end
	             }
	           end
	         }


---
### frontend/views/resources/_toolbar.html.erb 

Change option defaults on EAD export to "Use numbered <c> tags" _checked._

	             <label class="checkbox" for="numbered-cs">
	-              <input type="checkbox" id="numbered-cs" name="numbered_cs" />
	+              <input type="checkbox" id="numbered-cs" name="numbered_cs"  checked="checked" />
	               <%= I18n.t("export_options.numbered_cs") %>&#160;
	             </label>

---	             
### schemas/resource.rb

Make extents not required for resources so we can import our legacy EAD guides
and use ArchivesSpace to edit. 

	@@ -55,8 +55,8 @@
	       "finding_aid_status" => {"type" => "string", "dynamic_enum" => "resource_finding_aid_status"},
	       "finding_aid_note" => {"type" => "string", "maxLength" => 65000},
	 
	-      # Extents (overrides abstract schema)
	-      "extents" => {"type" => "array", "ifmissing" => "error", "minItems" => 1, "items" => {"type" => "J
	+      # Extents (overrides default schema: no longer required)
	+      "extents" => {"type" => "array",  "minItems" => 0, "items" => {"type" => "JSONModel(:extent) objec
	       
	       # Dates (overrides abstract schema)
	       "dates" => {"type" => "array", "ifmissing" => "error", "minItems" => 1, "items" => {"type" => "JSO
	
	
	    