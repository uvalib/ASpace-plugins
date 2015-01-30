
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