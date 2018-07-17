class SongsController < ApplicationController

  get '/songs' do
    @songs = Song.all

    erb :'songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all

    erb :'songs/new'
  end

  post '/songs/new' do
    Artist.all.each do |a|
      if a.name == params[:song][:artist]
        @artist = a
      end
    end

    if !Artist.all.include?(@artist)
      @artist = Artist.create(name: params[:song][:artist])
    end

    @genres = Genre.find(params[:genres])
    @song = Song.create(name: params[:song][:name], genres: @genres, artist_id: @artist.id)

    redirect to "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @artist = Artist.find(@song.artist_id)

    songgenre = SongGenre.find_by song_id: @song.id
    @genre = Genre.find(songgenre.genre_id)

    erb :'songs/show'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    @genres = Genre.all

    erb:'songs/edit'
  end

  post '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
        @song.update(params[:song])
        @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
        @song.save


        redirect("/songs/#{@song.slug}")
  end
end
