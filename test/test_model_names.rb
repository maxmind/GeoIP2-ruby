# frozen_string_literal: true

require 'maxmind/geoip2'
require 'minitest/autorun'

class ModelNameTest < Minitest::Test # :nodoc:
  RAW = {
    'continent' => {
      'code' => 'NA',
      'geoname_id' => 42,
      'names' => {
        'en' => 'North America',
        'zh-CN' => '北美洲',
      },
    },
    'country' => {
      'geoname_id' => 1,
      'iso_code' => 'US',
      'names' => {
        'en' => 'United States of America',
        'ru' => 'объединяет государства',
        'zh-CN' => '美国',
      },
    },
    'traits' => {
      'ip_address' => '1.2.3.4',
    },
  }.freeze

  def test_fallback
    model = MaxMind::GeoIP2::Model::Country.new(RAW, %w[ru zh-CN en])
    assert_equal('北美洲', model.continent.name)
    assert_equal('объединяет государства', model.country.name)
  end

  def test_two_fallbacks
    model = MaxMind::GeoIP2::Model::Country.new(RAW, %w[ru jp])
    assert_nil(model.continent.name)
    assert_equal('объединяет государства', model.country.name)
  end

  def test_no_fallbacks
    model = MaxMind::GeoIP2::Model::Country.new(RAW, %w[jp])
    assert_nil(model.continent.name)
    assert_nil(model.country.name)
  end
end
