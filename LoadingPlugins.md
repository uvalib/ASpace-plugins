A bit of confusion about where exactly to put plugin code as I’ve seen different placement in
examples and they don’t always exactly follow app layout. 
It turns out that only backend/model, backend/model/mixinx, backend/model/reports, and backend/controllers
gets automatically loaded:

[backend/app/main.rb#L103](https://github.com/archivesspace/archivesspace/blob/master/backend/app/main.rb#L103)


	[File.dirname(__FILE__), *ASUtils.find_local_directories('backend')].each do |prefix|
		['model/mixins', 'model', 'model/reports', 'controllers'].each do |path|
			Dir.glob(File.join(prefix, path, "*.rb")).sort.each do |file|
				require File.absolute_path(file)
			end
		end
	end



The empty directories in the ASpace distrubution 
`plugins/local/backend` directory includes those directories above, and I assume
the others in `plugins/local` do the same. 




Then later @ [backend/app/main.rb@L175](https://github.com/archivesspace/archivesspace/blob/master/backend/app/main.rb#L175)


	# Load plugin init.rb files (if present)
	ASUtils.find_local_directories('backend').each do |dir|
		init_file = File.join(dir, "plugin_init.rb")
		if File.exists?(init_file)
			load init_file
		end
	end


So, for example:  [aspace-110-plugin/blob/master/backend/plugin_init.rb](https://github.com/archivesspace/aspace-110-plugin/blob/master/backend/plugin_init.rb)
contains:

	require_relative 'lib/ead_converter.rb'
	require_relative 'lib/ead_serializer.rb'

to load files from backend/lib/


 