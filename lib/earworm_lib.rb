require 'dl/import'
module EarwormLib # :nodoc:
  extend DL::Importable
  dlload('/opt/local/lib/libofa.dylib')
  extern "void ofa_get_version(int *, int *, int *)"
  extern "const char * ofa_create_print(const char *, int, long, int, int)"
end
