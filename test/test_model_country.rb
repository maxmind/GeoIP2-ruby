# frozen_string_literal: true

require 'maxmind/geoip2'
require 'minitest/autorun'

class CountryModelTest < Minitest::Test
  RAW = {
    'continent' => {
      'code' => 'NA',
      'geoname_id' => 42,
      'names' => { 'en' => 'North America' },
    },
    'country' => {
      'geoname_id' => 1,
      'iso_code' => 'US',
      'names' => { 'en' => 'United States of America' },
    },
    'registered_country' => {
      'geoname_id' => 2,
      'is_in_european_union' => true,
      'iso_code' => 'DE',
      'names' => { 'en' => 'Germany' },
    },
    'traits' => {
      'ip_address' => '1.2.3.4',
      'prefix_length' => 24,
    },
  }.freeze

  def test_objects
    model = MaxMind::GeoIP2::Model::Country.new(RAW, ['en'])

    assert_instance_of(MaxMind::GeoIP2::Model::Country, model)
    assert_instance_of(MaxMind::GeoIP2::Record::Continent, model.continent)
    assert_instance_of(MaxMind::GeoIP2::Record::Country, model.country)
    assert_instance_of(
      MaxMind::GeoIP2::Record::Country, model.registered_country,
    )
    assert_instance_of(
      MaxMind::GeoIP2::Record::RepresentedCountry, model.represented_country,
    )
    assert_instance_of(
      MaxMind::GeoIP2::Record::Traits, model.traits,
    )
  end

  def test_values
    model = MaxMind::GeoIP2::Model::Country.new(RAW, ['en'])

    assert_equal(42, model.continent.geoname_id)
    assert_equal('NA', model.continent.code)
    assert_equal({ 'en' => 'North America' }, model.continent.names)
    assert_equal('North America', model.continent.name)

    assert_equal(1, model.country.geoname_id)
    refute(model.country.in_european_union?)
    assert_equal('US', model.country.iso_code)
    assert_equal({ 'en' => 'United States of America' }, model.country.names)
    assert_equal('United States of America', model.country.name)
    assert_nil(model.country.confidence)

    assert_equal(2, model.registered_country.geoname_id)
    assert(model.registered_country.in_european_union?)
    assert_equal('DE', model.registered_country.iso_code)
    assert_equal({ 'en' => 'Germany' }, model.registered_country.names)
    assert_equal('Germany', model.registered_country.name)
  end

  def test_unknown_record
    model = MaxMind::GeoIP2::Model::Country.new(RAW, ['en'])
    assert_raises(NoMethodError) { model.unknown_record }
  end

  def test_unknown_trait
    model = MaxMind::GeoIP2::Model::Country.new(RAW, ['en'])
    assert_raises(NoMethodError) { model.traits.unknown }
  end

  # This can happen if we're being created from a not fully populated response
  # when used by minFraud. It shouldn't ever happen from GeoIP2 though.
  def test_no_traits
    model = MaxMind::GeoIP2::Model::Country.new(
      {
        'continent' => {
          'code' => 'NA',
          'geoname_id' => 42,
          'names' => { 'en' => 'North America' },
        },
      },
      ['en'],
    )

    assert_equal(42, model.continent.geoname_id)
  end
end
