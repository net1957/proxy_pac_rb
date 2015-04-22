# encoding: utf-8
module ProxyPacRb
  # Compress javascript files
  class ProxyPacCompressor
    def compress(proxy_pac)
      compress_options = {
        sequences: false,      # Allow statements to be joined by commas
        # properties: true,     # Rewrite property access using the dot notation
        # dead_code: true,      # Remove unreachable code
        # drop_debugger: true,  # Remove debugger; statements
        # unsafe: false,        # Apply "unsafe" transformations
        # conditionals: true,   # Optimize for if-s and conditional expressions
        # comparisons: true,    # Apply binary node optimizations for comparisons
        # evaluate: true,       # Attempt to evaluate constant expressions
        # booleans: true,       # Various optimizations to boolean contexts
        # loops: true,          # Optimize loops when condition can be statically determined
        # unused: true,         # Drop unreferenced functions and variables
        # hoist_funs: true,     # Hoist function declarations
        # hoist_vars: false,    # Hoist var declarations
        # if_return: true,      # Optimizations for if/return and if/continue
        # join_vars: true,      # Join consecutive var statements
        # cascade: true,        # Cascade sequences
        # negate_iife: true,    # Negate immediately invoked function expressions to avoid extra parens
        # pure_getters: false,  # Assume that object property access does not have any side-effects
        # pure_funcs: nil,      # List of functions without side-effects. Can safely discard function calls when the result value is not used
        # drop_console: false,  # Drop calls to console.* functions
        # angular: false,       # Process @ngInject annotations
        # keep_fargs: false,     # Preserve unused function arguments
        # keep_fnames: true     # Preserve function names
      }

      options = {
        compress: compress_options
      }

      proxy_pac.content = Uglifier.new(options).compile(proxy_pac.content)
    end
  end
end
