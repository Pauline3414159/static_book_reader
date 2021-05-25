require 'bundler/setup'
require 'sinatra'
require "sinatra/reloader" if development?
require 'tilt/erubis'
require_relative ("data/book")

before do
  @book = Book.new("The Adventures of Sherlock Holmes", "Arthur Conan Doyle")
end

get "/" do
  
  erb :home
end

get "/chapters/:num" do
  @chapter_number = params[:num].to_i
  @prev_chapter = !!((@chapter_number.to_i - 1) >= 1)
  @next_chapter = !!((@chapter_number.to_i + 1 ) < @book.contents.size)
  erb :chapters
end

get "/search" do
  erb :search
end

get "/search/results" do
  @terms = params[:search_q]
  erb :results
end