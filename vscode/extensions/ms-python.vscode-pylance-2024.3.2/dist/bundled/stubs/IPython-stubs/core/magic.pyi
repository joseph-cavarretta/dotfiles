"""
This type stub file was generated by pyright.
"""

from traitlets.config.configurable import Configurable

"""Magic functions for InteractiveShell.
"""
magics = ...
magic_kinds = ...
magic_spec = ...
magic_escapes = ...
class Bunch:
    ...


def on_off(tag):
    """Return an ON/OFF string for a 1/0 input. Simple utility function."""
    ...

def compress_dhist(dh):
    """Compress a directory history into a new one with at most 20 entries.

    Return a new list made from the first and last 10 elements of dhist after
    removal of duplicates.
    """
    ...

def needs_local_scope(func):
    """Decorator to mark magic functions which need to local scope to run."""
    ...

def magics_class(cls):
    """Class decorator for all subclasses of the main Magics class.

    Any class that subclasses Magics *must* also apply this decorator, to
    ensure that all the methods that have been decorated as line/cell magics
    get correctly registered in the class instance.  This is necessary because
    when method decorators run, the class does not exist yet, so they
    temporarily store their information into a module global.  Application of
    this class decorator copies that global data to the class instance and
    clears the global.

    Obviously, this mechanism is not thread-safe, which means that the
    *creation* of subclasses of Magic should only be done in a single-thread
    context.  Instantiation of the classes has no restrictions.  Given that
    these classes are typically created at IPython startup time and before user
    application code becomes active, in practice this should not pose any
    problems.
    """
    ...

def record_magic(dct, magic_kind, magic_name, func): # -> None:
    """Utility function to store a function as a magic of a specific kind.

    Parameters
    ----------
    dct : dict
        A dictionary with 'line' and 'cell' subdicts.
    magic_kind : str
        Kind of magic to be stored.
    magic_name : str
        Key to store the magic as.
    func : function
        Callable object to store.
    """
    ...

def validate_type(magic_kind): # -> None:
    """Ensure that the given magic_kind is valid.

    Check that the given magic_kind is one of the accepted spec types (stored
    in the global `magic_spec`), raise ValueError otherwise.
    """
    ...

_docstring_template = ...
MAGIC_NO_VAR_EXPAND_ATTR = ...
MAGIC_OUTPUT_CAN_BE_SILENCED = ...
def no_var_expand(magic_func):
    """Mark a magic function as not needing variable expansion

    By default, IPython interprets `{a}` or `$a` in the line passed to magics
    as variables that should be interpolated from the interactive namespace
    before passing the line to the magic function.
    This is not always desirable, e.g. when the magic executes Python code
    (%timeit, %time, etc.).
    Decorate magics with `@no_var_expand` to opt-out of variable expansion.

    .. versionadded:: 7.3
    """
    ...

def output_can_be_silenced(magic_func):
    """Mark a magic function so its output may be silenced.

    The output is silenced if the Python code used as a parameter of
    the magic ends in a semicolon, not counting a Python comment that can
    follow it.
    """
    ...

line_magic = ...
cell_magic = ...
line_cell_magic = ...
register_line_magic = ...
register_cell_magic = ...
register_line_cell_magic = ...
class MagicsManager(Configurable):
    """Object that handles all magic-related functionality for IPython.
    """
    magics = ...
    lazy_magics = ...
    registry = ...
    shell = ...
    auto_magic = ...
    _auto_status = ...
    user_magics = ...
    def __init__(self, shell=..., config=..., user_magics=..., **traits) -> None:
        ...
    
    def auto_status(self):
        """Return descriptive string with automagic status."""
        ...
    
    def lsmagic(self): # -> Dict:
        """Return a dict of currently available magic functions.

        The return dict has the keys 'line' and 'cell', corresponding to the
        two types of magics we support.  Each value is a list of names.
        """
        ...
    
    def lsmagic_docs(self, brief=..., missing=...):
        """Return dict of documentation of magic functions.

        The return dict has the keys 'line' and 'cell', corresponding to the
        two types of magics we support. Each value is a dict keyed by magic
        name whose value is the function docstring. If a docstring is
        unavailable, the value of `missing` is used instead.

        If brief is True, only the first line of each docstring will be returned.
        """
        ...
    
    def register_lazy(self, name: str, fully_qualified_name: str): # -> None:
        """
        Lazily register a magic via an extension.


        Parameters
        ----------
        name : str
            Name of the magic you wish to register.
        fully_qualified_name :
            Fully qualified name of the module/submodule that should be loaded
            as an extensions when the magic is first called.
            It is assumed that loading this extensions will register the given
            magic.
        """
        ...
    
    def register(self, *magic_objects): # -> None:
        """Register one or more instances of Magics.

        Take one or more classes or instances of classes that subclass the main
        `core.Magic` class, and register them with IPython to use the magic
        functions they provide.  The registration process will then ensure that
        any methods that have decorated to provide line and/or cell magics will
        be recognized with the `%x`/`%%x` syntax as a line/cell magic
        respectively.

        If classes are given, they will be instantiated with the default
        constructor.  If your classes need a custom constructor, you should
        instanitate them first and pass the instance.

        The provided arguments can be an arbitrary mix of classes and instances.

        Parameters
        ----------
        *magic_objects : one or more classes or instances
        """
        ...
    
    def register_function(self, func, magic_kind=..., magic_name=...): # -> None:
        """Expose a standalone function as magic function for IPython.

        This will create an IPython magic (line, cell or both) from a
        standalone function.  The functions should have the following
        signatures:

        * For line magics: `def f(line)`
        * For cell magics: `def f(line, cell)`
        * For a function that does both: `def f(line, cell=None)`

        In the latter case, the function will be called with `cell==None` when
        invoked as `%f`, and with cell as a string when invoked as `%%f`.

        Parameters
        ----------
        func : callable
            Function to be registered as a magic.
        magic_kind : str
            Kind of magic, one of 'line', 'cell' or 'line_cell'
        magic_name : optional str
            If given, the name the magic will have in the IPython namespace.  By
            default, the name of the function itself is used.
        """
        ...
    
    def register_alias(self, alias_name, magic_name, magic_kind=..., magic_params=...): # -> None:
        """Register an alias to a magic function.

        The alias is an instance of :class:`MagicAlias`, which holds the
        name and kind of the magic it should call. Binding is done at
        call time, so if the underlying magic function is changed the alias
        will call the new function.

        Parameters
        ----------
        alias_name : str
            The name of the magic to be registered.
        magic_name : str
            The name of an existing magic.
        magic_kind : str
            Kind of magic, one of 'line' or 'cell'
        """
        ...
    


class Magics(Configurable):
    """Base class for implementing magic functions.

    Shell functions which can be reached as %function_name. All magic
    functions should accept a string, which they can parse for their own
    needs. This can make some functions easier to type, eg `%cd ../`
    vs. `%cd("../")`

    Classes providing magic functions need to subclass this class, and they
    MUST:

    - Use the method decorators `@line_magic` and `@cell_magic` to decorate
      individual methods as magic functions, AND

    - Use the class decorator `@magics_class` to ensure that the magic
      methods are properly registered at the instance level upon instance
      initialization.

    See :mod:`magic_functions` for examples of actual implementation classes.
    """
    options_table = ...
    magics = ...
    registered = ...
    shell = ...
    def __init__(self, shell=..., **kwargs) -> None:
        ...
    
    def arg_err(self, func): # -> None:
        """Print docstring if incorrect arguments were passed"""
        ...
    
    def format_latex(self, strng):
        """Format a string for latex inclusion."""
        ...
    
    def parse_options(self, arg_str, opt_str, *long_opts, **kw):
        """Parse options passed to an argument string.

        The interface is similar to that of :func:`getopt.getopt`, but it
        returns a :class:`~IPython.utils.struct.Struct` with the options as keys
        and the stripped argument string still as a string.

        arg_str is quoted as a true sys.argv vector by using shlex.split.
        This allows us to easily expand variables, glob files, quote
        arguments, etc.

        Parameters
        ----------
        arg_str : str
            The arguments to parse.
        opt_str : str
            The options specification.
        mode : str, default 'string'
            If given as 'list', the argument string is returned as a list (split
            on whitespace) instead of a string.
        list_all : bool, default False
            Put all option values in lists. Normally only options
            appearing more than once are put in a list.
        posix : bool, default True
            Whether to split the input line in POSIX mode or not, as per the
            conventions outlined in the :mod:`shlex` module from the standard
            library.
        """
        ...
    
    def default_option(self, fn, optstr): # -> None:
        """Make an entry in the options_table for fn, with value optstr"""
        ...
    


class MagicAlias:
    """An alias to another magic function.

    An alias is determined by its magic name and magic kind. Lookup
    is done at call time, so if the underlying magic changes the alias
    will call the new function.

    Use the :meth:`MagicsManager.register_alias` method or the
    `%alias_magic` magic function to create and register a new alias.
    """
    def __init__(self, shell, magic_name, magic_kind, magic_params=...) -> None:
        ...
    
    def __call__(self, *args, **kwargs):
        """Call the magic alias."""
        ...
    


