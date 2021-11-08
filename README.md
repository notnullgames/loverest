# loverest

This is a simple wrapper around the sort of REST services that receive JSON, and return it.

## installation

There are a few dependencies that need to be in your require-path. If you already have [bitser](https://github.com/gvx/bitser), [luajit-request](https://github.com/LPGhatguy/luajit-request), [dkjson](https://github.com/LuaDist/dkjson), [lovehandles](https://github.com/notnullgames/lovehandles) in your path, you're good. They are usefule libraries, seperately, so might come in handly, anyway. You also need libcurl installed. It comes with mac & generally comes with most linux distros (and is easy to install.) For windows, you can include the libcurl DLL along with your game, or tell your users to install it seperately.

The easiest way I have found to create the lua-deps is to just create a bunch of submodules in a dir:

```
git init
mkdir lib
cd lib

git submodule add https://github.com/gvx/bitser.git
git submodule add https://github.com/LPGhatguy/luajit-request.git
git submodule add https://github.com/LuaDist/dkjson.git
git submodule add https://github.com/notnullgames/lovehandles.git
git submodule add https://github.com/notnullgames/loverest.git
```

Then setup all the paths (in main.lua):

```lua
local add_path = require('lib.lovehandles.add_path')

add_path("lib/lovehandles")
add_path("lib/bitser")
add_path("lib/luajit-request")
add_path("lib/dkjson")

local rest = require("loverest")
```

Now, users can `git clone --recursive` your git repo, and it's super easy to deal with.

## usage

Basic usage looks like this:

```lua
local handle = rest:get("https://swapi.dev/api/people")

-- later
local data, error = handle()
if data and not error then
  -- do something with data
end
```

data & error are cached after first request, and you can overwrite handle by calling `rest.get`, again.

See [example/](example/) for a more complete example, and you can run `love example`.


### api

```lua
-- Perform a GET request
function rest:get(url, options) end

-- Perform a POST request
function rest:post(url, input, options) end

-- Perform a PUT request
function rest:put(url, input, options) end

-- Perform a PATCH request
function rest:patch(url, input, options) end

-- Perform a DELETE request
function rest:delete(url, input, options) end

-- Perform a HEAD request
function rest:head(url, options) end

-- Don't manage input/output, just return the raw request-object
function rest:request(url, options) end
```

`options` is optional, and supports any options available [here](https://github.com/LPGhatguy/luajit-request).

`input` optional, and is a regular lua table object, for input params, and will be converted to JSON.

### future ideas

- web-support - I am using threads & libcurl FFI, which are both not supported in lovejs, but I could make them work with a little wrapping (and using native browser APIs)
- windows with curl - mac & linux are pretty simple to work with libcurl, but windows doesn't have it by default, so another method would be helpful.


### related

- [REST-love](https://github.com/MrcSnm/REST-love) is another great option. It uses curl CLI (instead of libcurl) on mac/linux, and has no-lib windows & web support (in lovejs.) If this library worked a little differently, I probably would not have made my library. Great option for much better cross-target support.
- [luajit-request](https://github.com/LPGhatguy/luajit-request) is the lib this lib uses to make requests. It's synchronous, so not great in graphical stuff, in love, but it will work (albeit blocking.) This is a great option if you don't need async (non-blocking) HTTP client library.