require'slim'
require'sqlite3'
require'sinatra'
require 'byebug'
require 'BCrypt'
require_relative 'fil'
enable :sessions

get('/') do
    slim(:index)
end

post('/login') do
    variable = logingin(params["email"], params["password"])
    if variable == nil
        redirect('/')
    else
        session[:id] = variable
        redirect('/lhome')      
    end
end

get('/create') do
    slim(:create)
end

post('/created') do
    create_user(params["email"],params["namn"],params["password"])
    redirect('/')
end

get('/lhome') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        session[:name] = getname(session[:id])
        id = "*"
        posts = getposts(id)
        slim(:lhome, locals:{
            posts: posts
        })
    end
end

post('/logout') do
    session.destroy
    redirect('/')
end

get('/profile') do
    posts = getposts(session[:id])
    slim(:profile, locals:{
        posts: posts
    })
end

get('/cpo') do
    slim(:cpo)
end

post('/createpost') do
    createp(session[:id], params["text"], params["img"])
    redirect('/profile')
end

post('/profile/:id/delete') do
    delete(params["id"])
    redirect('/profile')
end