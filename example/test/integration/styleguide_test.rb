require 'test_helper'

class StyleguideTest < ActionDispatch::IntegrationTest
  test 'styleguides home' do
    get '/styleguides/'
    assert_select 'title', 'Styleguides'
    assert_select 'h1', 'Styleguides'
  end

  test 'redirect' do
    get '/styleguides'
    assert_equal 302, status
  end

  test 'styleguides css' do
    get '/styleguides/styledown/styleguide.css'
    assert_response :success
  end

  test 'styleguides js' do
    get '/styleguides/styledown/styleguide.js'
    assert_response :success
  end

  test 'figure css' do
    get '/styleguides/styledown/figure.css'
    assert_response :success
  end

  test 'figure js' do
    get '/styleguides/styledown/figure.js'
    assert_response :success
  end
end
