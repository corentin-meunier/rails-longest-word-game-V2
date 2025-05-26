require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].chars
    if !included_in_grid?(@word, @letters)
      @result = "Sorry but #{@word} can't be built out of #{@letters.join(' ')}"
    elsif !english_word?(@word)
      @result = "Sorry but #{@word} does not seem to be is a valid English word"
    else
      @result = "Congratulations! #{@word} is valid English word"
    end
  end

  private

  def included_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
