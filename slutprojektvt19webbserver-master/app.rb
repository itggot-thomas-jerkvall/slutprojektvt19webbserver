require'slim'
require'sqlite3'
require'sinatra'
require 'byebug'
require 'BCrypt'
#require 'fil'
enable :sessions


get('/') do
    slim(:index)
end