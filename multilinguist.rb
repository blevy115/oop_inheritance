require 'httparty'
require 'json'
# This class represents a world traveller who knows what languages are spoken in each country
# around the world and can cobble together a sentence in most of them (but not very well)
class Multilinguist

  TRANSLTR_BASE_URL = "http://bitmakertranslate.herokuapp.com"
  COUNTRIES_BASE_URL = "https://restcountries.eu/rest/v2/name"
  #{name}?fullText=true
  #?text=The%20total%20is%2020485&to=ja&from=en


  # Initializes the multilinguist's @current_lang to 'en'
  #
  # @return [Multilinguist] A new instance of Multilinguist
  def initialize
    @current_lang = 'en'
  end

  # Uses the RestCountries API to look up one of the languages
  # spoken in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] A 2 letter iso639_1 language code
  def language_in(country_name)
    params = {query: {fullText: 'true'}}
    response = HTTParty.get("#{COUNTRIES_BASE_URL}/#{country_name}", params)
    unless response.body == ""
      json_response = JSON.parse(response.body)
      json_response.first['languages'].first['iso639_1']
    else
      return "Error"
    end
  end

  # Sets @current_lang to one of the languages spoken
  # in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] The new value of @current_lang as a 2 letter iso639_1 code
  def travel_to(country_name)
    local_lang = language_in(country_name)
    @current_lang = local_lang
  end

  # (Roughly) translates msg into @current_lang using the Transltr API
  #
  # @param msg [String] A message to be translated
  # @return [String] A rough translation of msg
  def say_in_local_language(msg)
    params = {query: {text: msg, to: @current_lang, from: 'en'}}
    response = HTTParty.get(TRANSLTR_BASE_URL, params)
    json_response = JSON.parse(response.body)
    json_response['translationText']
  end
end

class MathGenius < Multilinguist

  def report_total(number_list)
    sum = 0
    number_list.each { |number| sum += number}
    puts "#{say_in_local_language("The total is")} #{sum}"
  end

end

class QuoteCollector < Multilinguist

  def initialize
    super
    @favourite_quotes =[]
  end

  def favourite_quotes
    @favourite_quotes
  end

  def add_fav_quote(quote)
    @favourite_quotes << say_in_local_language(quote)
  end

  def random_quote
    puts @favourite_quotes[rand(@favourite_quotes.length)]
  end
end


# me = MathGenius.new
# puts me.report_total([23,45,676,34,5778,4,23,5465]) # The total is 12048
# me.travel_to("India")
# puts me.report_total([6,3,6,68,455,4,467,57,4,534]) # है को कुल 1604
# me.travel_to("Italy")
# puts me.report_total([324,245,6,343647,686545]) # È Il totale 1030767
