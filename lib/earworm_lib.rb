require 'dl/import'
module EarwormLib # :nodoc:
  extend DL::Importable
  loaded = false
  libs = %w{ libofa.dylib libofa.so libofa.so.0 }
  dirs = %w{ /opt/local/lib /usr/local/lib }
  libs += libs.map { |lib| dirs.map { |dir| File.join(dir, lib) } }.flatten
  libs.each do |so|
    begin
      dlload(so)
      loaded = true
      break
    rescue
      next
    end
  end
  raise "Please install libofa" unless loaded

  extern "void ofa_get_version(int *, int *, int *)"
  extern "const char * ofa_create_print(const char *, int, long, int, int)"
end
