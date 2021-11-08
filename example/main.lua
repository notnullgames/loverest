local add_path = require('lib.lovehandles.add_path')

add_path("lib/lovehandles")
add_path("lib/bitser")
add_path("lib/luajit-request")
add_path("lib/dkjson")

local rest = require("loverest")

-- this will hold the handle to the request
local get_people

-- this holds the people object, once the request is finished (between update() and draw())
local people = {}

-- I only need to do this once
local screen_width = love.graphics.getWidth()
local screen_height = love.graphics.getHeight()

function love.load()
  get_people = rest:get("https://swapi.dev/api/people")
end

function love.update(dt)
  local _people, error = get_people()
  if #people == 0 and _people and not error then
    people = _people.results
    print("grabbed " .. #people .. " people.")
  end
end

function love.draw()
  if #people == 0 then
    love.graphics.printf("Getting first page of Star Wars characters...", 10, (screen_height/2) - 6, screen_width, "center")
  end
  for i, person in pairs(people) do
    local y = (i-1) * 50
    love.graphics.printf("name: " .. person["name"], 10, 10 + y, screen_width, "left")
    love.graphics.printf("gender: " .. person["gender"], 10, 24 + y, screen_width, "left")
    love.graphics.printf("birth year: " .. person["birth_year"], 10, 38 + y, screen_width, "left")
  end
end