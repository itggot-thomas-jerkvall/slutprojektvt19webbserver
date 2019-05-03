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
        posts = getallposts_with_votes()
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
    if loggedin(session[:id]) == false
        redirect('/')
    else
        posts = getposts(session[:id])
        slim(:profile, locals:{
            posts: posts
        })
    end
end

get('/cpo') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        slim(:cpo)
    end
end

post('/createpost') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        createp(session[:id], params["text"], params["img"])
        redirect('/profile')
    end
end

post('/profile/:id/delete') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        delete(params["id"])
        redirect('/profile')
    end
end

get('/lhome/:id/upvote') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        vote(session[:id], params["id"], 1)
        redirect('/lhome')
    end
end

get('/lhome/:id/downvote') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        vote(session[:id], params["id"], -1)
        redirect('/lhome')
    end
end