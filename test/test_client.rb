# frozen_string_literal: true

require 'json'
require 'maxmind/geoip2'
require 'minitest/autorun'
require 'webmock/minitest'

class ClientTest < Minitest::Test
  COUNTRY = {
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
    'maxmind' => {
      'queries_remaining' => 11,
    },
    'traits' => {
      'ip_address' => '1.2.3.4',
      'is_anycast' => true,
      'network' => '1.2.3.0/24',
    },
  }.freeze

  INSIGHTS = {
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
    'maxmind' => {
      'queries_remaining' => 11,
    },
    'traits' => {
      'ip_address' => '1.2.3.40',
      'is_anycast' => true,
      'is_residential_proxy' => true,
      'network' => '1.2.3.0/24',
      'static_ip_score' => 1.3,
      'user_count' => 2,
    },
  }.freeze

  CONTENT_TYPES = {
    country: 'application/vnd.maxmind.com-country+json; charset=UTF-8; version=2.1',
  }.freeze

  def test_country
    record = request(:country, '1.2.3.4')

    assert_instance_of(MaxMind::GeoIP2::Model::Country, record)

    assert_equal(42, record.continent.geoname_id)
    assert_equal('NA', record.continent.code)
    assert_equal({ 'en' => 'North America' }, record.continent.names)
    assert_equal('North America', record.continent.name)

    assert_equal(1, record.country.geoname_id)
    refute(record.country.in_european_union?)
    assert_equal('US', record.country.iso_code)
    assert_equal({ 'en' => 'United States of America' }, record.country.names)
    assert_equal('United States of America', record.country.name)

    assert_equal(11, record.maxmind.queries_remaining)

    refute(record.registered_country.in_european_union?)

    assert(record.traits.anycast?)
    assert_equal('1.2.3.0/24', record.traits.network)
  end

  def test_insights
    record = request(:insights, '1.2.3.40')

    assert_instance_of(MaxMind::GeoIP2::Model::Insights, record)

    assert_equal(42, record.continent.geoname_id)

    assert(record.traits.anycast?)
    assert(record.traits.residential_proxy?)
    assert_equal('1.2.3.0/24', record.traits.network)
    assert_in_delta(1.3, record.traits.static_ip_score)
    assert_equal(2, record.traits.user_count)
  end

  def test_city
    record = request(:city, '1.2.3.4')

    assert_instance_of(MaxMind::GeoIP2::Model::City, record)

    assert_equal('1.2.3.0/24', record.traits.network)
  end

  def test_me
    record = request(:city, 'me')

    assert_instance_of(MaxMind::GeoIP2::Model::City, record)
  end

  def test_no_body_error
    assert_raises(
      JSON::ParserError,
    ) { request(:country, '1.2.3.5') }
  end

  def test_bad_body_error
    assert_raises(
      JSON::ParserError,
    ) { request(:country, '2.2.3.5') }
  end

  def test_non_json_success_response
    error = assert_raises(
      MaxMind::GeoIP2::HTTPError,
    ) { request(:country, '3.2.3.5') }

    assert_equal(
      'Received a success response for country but it is not JSON: extra bad body',
      error.message,
    )
  end

  def test_invalid_ip_error_from_web_service
    error = assert_raises(
      MaxMind::GeoIP2::AddressInvalidError,
    ) { request(:country, '1.2.3.6') }

    assert_equal(
      'The value "1.2.3" is not a valid IP address',
      error.message,
    )
  end

  def test_invalid_ip_error_from_client
    error = assert_raises(
      MaxMind::GeoIP2::AddressInvalidError,
    ) { request(:country, '1.2.3') }

    assert_equal(
      'The value "1.2.3" is not a valid IP address',
      error.message,
    )
  end

  def test_no_error_body_ip_error
    assert_raises(
      JSON::ParserError,
    ) { request(:country, '1.2.3.7') }
  end

  def test_missing_key_ip_error
    error = assert_raises(
      MaxMind::GeoIP2::HTTPError,
    ) { request(:country, '1.2.3.71') }

    assert_equal(
      'Received client error response (400) that is JSON but does not specify code or error keys: {"code":"HI"}',
      error.message,
    )
  end

  def test_weird_error_body_ip_error
    error = assert_raises(
      MaxMind::GeoIP2::HTTPError,
    ) { request(:country, '1.2.3.8') }

    assert_equal(
      'Received client error response (400) that is JSON but does not specify code or error keys: {"weird":42}',
      error.message,
    )
  end

  def test_500_error
    error = assert_raises(
      MaxMind::GeoIP2::HTTPError,
    ) { request(:country, '1.2.3.10') }

    assert_equal(
      'Received server error response (500) for country with body foo',
      error.message,
    )
  end

  def test_300_response
    error = assert_raises(
      MaxMind::GeoIP2::HTTPError,
    ) { request(:country, '1.2.3.11') }

    assert_equal(
      'Received unexpected response (300) for country with body bar',
      error.message,
    )
  end

  def test_406_error
    error = assert_raises(
      MaxMind::GeoIP2::HTTPError,
    ) { request(:country, '1.2.3.12') }

    assert_equal(
      'Received client error response (406) for country but it is not JSON: Cannot satisfy your Accept-Charset requirements',
      error.message,
    )
  end

  def test_address_not_found_error
    error = assert_raises(
      MaxMind::GeoIP2::AddressNotFoundError,
    ) { request(:country, '1.2.3.13') }

    assert_equal(
      'The address "1.2.3.13" is not in our database.',
      error.message,
    )
  end

  def test_address_reserved_error
    error = assert_raises(
      MaxMind::GeoIP2::AddressReservedError,
    ) { request(:country, '1.2.3.14') }

    assert_equal(
      'The address "1.2.3.14" is a private address.',
      error.message,
    )
  end

  def test_authorization_error
    error = assert_raises(
      MaxMind::GeoIP2::AuthenticationError,
    ) { request(:country, '1.2.3.15') }

    assert_equal(
      'An account ID and license key are required to use this service.',
      error.message,
    )
  end

  def test_missing_license_key_error
    error = assert_raises(
      MaxMind::GeoIP2::AuthenticationError,
    ) { request(:country, '1.2.3.16') }

    assert_equal(
      'A license key is required to use this service.',
      error.message,
    )
  end

  def test_missing_account_id_error
    error = assert_raises(
      MaxMind::GeoIP2::AuthenticationError,
    ) { request(:country, '1.2.3.17') }

    assert_equal(
      'An account ID is required to use this service.',
      error.message,
    )
  end

  def test_insufficient_funds_error
    error = assert_raises(
      MaxMind::GeoIP2::InsufficientFundsError,
    ) { request(:country, '1.2.3.18') }

    assert_equal(
      'The license key you have provided is out of queries.',
      error.message,
    )
  end

  def test_unexpected_code_error
    error = assert_raises(
      MaxMind::GeoIP2::InvalidRequestError,
    ) { request(:country, '1.2.3.19') }

    assert_equal(
      'Whoa!',
      error.message,
    )
  end

  def request(method, ip_address)
    response = get_response(ip_address)

    stub_request(:get, /geoip/)
      .to_return(
        body: response[:body],
        headers: response[:headers],
        status: response[:status],
      )

    client = MaxMind::GeoIP2::Client.new(
      account_id: 42,
      license_key: 'abcdef123456',
    )

    client.send(method, ip_address)
  end

  def get_response(ip_address)
    responses = {
      'me' => {
        body: JSON.generate(COUNTRY),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 200,
      },
      '1.2.3' => {},
      '1.2.3.4' => {
        body: JSON.generate(COUNTRY),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 200,
      },
      '1.2.3.5' => {
        body: '',
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 200,
      },
      '2.2.3.5' => {
        body: 'bad body',
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 200,
      },
      '3.2.3.5' => {
        body: 'extra bad body',
        headers: {},
        status: 200,
      },
      '1.2.3.40' => {
        body: JSON.generate(INSIGHTS),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 200,
      },
      '1.2.3.6' => {
        body: JSON.generate({
                              'code' => 'IP_ADDRESS_INVALID',
                              'error' => 'The value "1.2.3" is not a valid IP address',
                            }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 400,
      },
      '1.2.3.7' => {
        body: '',
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 400,
      },
      '1.2.3.71' => {
        body: JSON.generate({ code: 'HI' }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 400,
      },
      '1.2.3.8' => {
        body: JSON.generate({ weird: 42 }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 400,
      },
      '1.2.3.10' => {
        body: 'foo',
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 500,
      },
      '1.2.3.11' => {
        body: 'bar',
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 300,
      },
      '1.2.3.12' => {
        body: 'Cannot satisfy your Accept-Charset requirements',
        headers: {},
        status: 406,
      },
      '1.2.3.13' => {
        body: JSON.generate({
                              'code' => 'IP_ADDRESS_NOT_FOUND',
                              'error' => 'The address "1.2.3.13" is not in our database.',
                            }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 400,
      },
      '1.2.3.14' => {
        body: JSON.generate({
                              'code' => 'IP_ADDRESS_RESERVED',
                              'error' => 'The address "1.2.3.14" is a private address.',
                            }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 400,
      },
      '1.2.3.15' => {
        body: JSON.generate({
                              'code' => 'AUTHORIZATION_INVALID',
                              'error' => 'An account ID and license key are required to use this service.',
                            }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 401,
      },
      '1.2.3.16' => {
        body: JSON.generate({
                              'code' => 'LICENSE_KEY_REQUIRED',
                              'error' => 'A license key is required to use this service.',
                            }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 401,
      },
      '1.2.3.17' => {
        body: JSON.generate({
                              'code' => 'ACCOUNT_ID_REQUIRED',
                              'error' => 'An account ID is required to use this service.',
                            }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 401,
      },
      '1.2.3.18' => {
        body: JSON.generate({
                              'code' => 'INSUFFICIENT_FUNDS',
                              'error' => 'The license key you have provided is out of queries.',
                            }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 402,
      },
      '1.2.3.19' => {
        body: JSON.generate({
                              'code' => 'UNEXPECTED',
                              'error' => 'Whoa!',
                            }),
        headers: { 'Content-Type': CONTENT_TYPES[:country] },
        status: 400,
      },
    }

    responses[ip_address]
  end
end
