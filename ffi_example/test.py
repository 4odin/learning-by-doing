import ctypes
import platform

def load_dll(path):
    """Loads a DLL file based on the operating system."""
    loader = ctypes.CDLL if platform.system() != "Windows" else ctypes.windll.LoadLibrary
    return loader(path)

# Simplified loading of the DLL with direct path inclusion.
dll_path = "./main.dll"
my_dll = load_dll(dll_path)

# Define the Config structure and Init function type more compactly.
class Config(ctypes.Structure):
    pass  # Placeholder for circular reference.

InitFuncType = ctypes.CFUNCTYPE(None, ctypes.POINTER(Config), ctypes.c_int)

# Immediately define the Config fields after its declaration.
Config._fields_ = [("x", ctypes.c_int), ("init_hook", InitFuncType)]

def my_init_function(config_ptr, x):
    """Custom init function to modify Config's x attribute."""
    print("custom initializer is called har har har")
    config_ptr.contents.x = x + 17



# Directly configure and call the exported number function.
my_dll.number.argtypes = [ctypes.c_int]
my_dll.number.restype = ctypes.c_int
print("Result from number:", my_dll.number(3))

# Preparing and invoking the init_config function.
my_dll.init_config.argtypes = [ctypes.POINTER(Config), ctypes.c_int]
my_dll.init_config.restype = None

my_dll.my_init_config.argtypes = [ctypes.POINTER(Config), ctypes.c_int]
my_dll.my_init_config.restype = None

# Improved structure and function preparation for clearer flow.
config_instance = Config()

print("Initial x:", config_instance.x)

my_dll.init_config(ctypes.byref(config_instance), 5)
print("Updated after default_init_config x:", config_instance.x)

config_instance.init_hook = InitFuncType(my_init_function)

my_dll.my_init_config(ctypes.byref(config_instance), 5)
print("Updated after my_init_config x:", config_instance.x)

my_dll.init_config(ctypes.byref(config_instance), 5)
print("Updated after init_config x:", config_instance.x)
