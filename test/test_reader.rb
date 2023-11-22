# frozen_string_literal: true

require 'ipaddr'
require 'maxmind/db'
require 'maxmind/geoip2'
require 'minitest/autorun'

class ReaderTest < Minitest::Test
  def test_anonymous_ip
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Anonymous-IP-Test.mmdb',
    )
    ip = '1.2.0.1'
    record = reader.anonymous_ip(ip)

    assert_equal(true, record.anonymous?)
    assert_equal(true, record.anonymous_vpn?)
    assert_equal(false, record.hosting_provider?)
    assert_equal(false, record.public_proxy?)
    assert_equal(false, record.residential_proxy?)
    assert_equal(false, record.tor_exit_node?)
    assert_equal(ip, record.ip_address)
    assert_equal('1.2.0.0/16', record.network)

    reader.close
  end

  def test_anonymous_ip_residential_proxy
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Anonymous-IP-Test.mmdb',
    )
    ip = '81.2.69.1'
    record = reader.anonymous_ip(ip)

    assert_equal(true, record.residential_proxy?)

    reader.close
  end

  def test_asn
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoLite2-ASN-Test.mmdb',
    )
    ip = '1.128.0.1'
    record = reader.asn(ip)

    assert_equal(1221, record.autonomous_system_number)
    assert_equal('Telstra Pty Ltd', record.autonomous_system_organization)
    assert_equal(ip, record.ip_address)
    assert_equal('1.128.0.0/11', record.network)

    reader.close
  end

  def test_city
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-City-Test.mmdb',
    )
    record = reader.city('2.125.160.216')

    assert_equal('EU', record.continent.code)

    assert_equal(2_655_045, record.city.geoname_id)
    assert_equal({ 'en' => 'Boxford' }, record.city.names)
    assert_equal('Boxford', record.city.name)
    assert_nil(record.city.confidence)

    assert_equal(100, record.location.accuracy_radius)
    assert_equal(51.75, record.location.latitude)
    assert_equal(-1.25, record.location.longitude)
    assert_equal('Europe/London', record.location.time_zone)

    assert_equal(2, record.subdivisions.size)
    assert_equal('England', record.subdivisions[0].name)
    assert_equal('West Berkshire', record.subdivisions[1].name)
    assert_equal('West Berkshire', record.most_specific_subdivision.name)

    record = reader.city('216.160.83.56')

    assert_equal(819, record.location.metro_code)

    assert_equal('98354', record.postal.code)

    assert_equal(1, record.subdivisions.size)
    assert_equal(5_815_135, record.subdivisions[0].geoname_id)
    assert_equal('WA', record.subdivisions[0].iso_code)
    assert_equal(
      {
        'en' => 'Washington',
        'es' => 'Washington',
        'fr' => 'État de Washington',
        'ja' => 'ワシントン州',
        'ru' => 'Вашингтон',
        'zh-CN' => '华盛顿州',
      },
      record.subdivisions[0].names,
      assert_equal('WA', record.most_specific_subdivision.iso_code)
    )

    reader.close
  end

  def test_city_no_subdivisions
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-City-Test.mmdb',
    )
    record = reader.city('2001:218::')

    assert_equal([], record.subdivisions)
    assert_nil(record.most_specific_subdivision)

    reader.close
  end

  def test_connection_type
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Connection-Type-Test.mmdb',
    )
    ip = '1.0.1.1'
    record = reader.connection_type(ip)

    assert_equal('Cellular', record.connection_type)
    assert_equal(ip, record.ip_address)
    assert_equal('1.0.1.0/24', record.network)

    reader.close
  end

  def test_country
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Country-Test.mmdb',
    )
    record = reader.country('2.125.160.216')

    assert_equal('EU', record.continent.code)
    assert_equal(6_255_148, record.continent.geoname_id)
    assert_equal(
      {
        'de' => 'Europa',
        'en' => 'Europe',
        'es' => 'Europa',
        'fr' => 'Europe',
        'ja' => 'ヨーロッパ',
        'pt-BR' => 'Europa',
        'ru' => 'Европа',
        'zh-CN' => '欧洲',
      },
      record.continent.names,
    )
    assert_equal('Europe', record.continent.name)

    assert_equal(2_635_167, record.country.geoname_id)
    assert_equal(false, record.country.in_european_union?)
    assert_equal('GB', record.country.iso_code)
    assert_equal(
      {
        'de' => 'Vereinigtes Königreich',
        'en' => 'United Kingdom',
        'es' => 'Reino Unido',
        'fr' => 'Royaume-Uni',
        'ja' => 'イギリス',
        'pt-BR' => 'Reino Unido',
        'ru' => 'Великобритания',
        'zh-CN' => '英国',
      },
      record.country.names,
    )
    assert_equal('United Kingdom', record.country.name)

    assert_equal(3_017_382, record.registered_country.geoname_id)
    assert_equal(true, record.registered_country.in_european_union?)
    assert_equal('FR', record.registered_country.iso_code)
    assert_equal(
      {
        'de' => 'Frankreich',
        'en' => 'France',
        'es' => 'Francia',
        'fr' => 'France',
        'ja' => 'フランス共和国',
        'pt-BR' => 'França',
        'ru' => 'Франция',
        'zh-CN' => '法国',
      },
      record.registered_country.names,
    )
    assert_equal('France', record.registered_country.name)

    record = reader.country('202.196.224.0')

    assert_equal(6_252_001, record.represented_country.geoname_id)
    assert_equal('US', record.represented_country.iso_code)
    assert_equal(
      {
        'de' => 'USA',
        'en' => 'United States',
        'es' => 'Estados Unidos',
        'fr' => 'États-Unis',
        'ja' => 'アメリカ合衆国',
        'pt-BR' => 'Estados Unidos',
        'ru' => 'США',
        'zh-CN' => '美国',
      },
      record.represented_country.names,
    )
    assert_equal('United States', record.represented_country.name)
    assert_equal('military', record.represented_country.type)

    record = reader.country('81.2.69.163')
    assert_equal('81.2.69.163', record.traits.ip_address)
    assert_equal('81.2.69.160/27', record.traits.network)

    assert_raises(NoMethodError) { record.foo }
    reader.close
  end

  def test_is_method_returns_false
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Country-Test.mmdb',
    )
    record = reader.country('74.209.24.0')
    assert_equal(false, record.country.in_european_union?)

    reader.close
  end

  def test_domain
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Domain-Test.mmdb',
    )
    ip = '1.2.0.1'
    record = reader.domain(ip)

    assert_equal('maxmind.com', record.domain)
    assert_equal(ip, record.ip_address)
    assert_equal('1.2.0.0/16', record.network)

    reader.close
  end

  def test_enterprise
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Enterprise-Test.mmdb',
    )
    record = reader.enterprise('2.125.160.216')

    assert_equal(50, record.city.confidence)
    assert_equal(2_655_045, record.city.geoname_id)
    assert_equal({ 'en' => 'Boxford' }, record.city.names)
    assert_equal('Boxford', record.city.name)

    ip_address = '74.209.24.0'
    record = reader.enterprise(ip_address)

    assert_equal(11, record.city.confidence)
    assert_equal(99, record.country.confidence)
    assert_equal(6_252_001, record.country.geoname_id)
    assert_equal(false, record.country.in_european_union?)

    assert_equal(27, record.location.accuracy_radius)

    assert_equal(false, record.registered_country.in_european_union?)

    assert_equal('Cable/DSL', record.traits.connection_type)
    assert_equal(true, record.traits.legitimate_proxy?)

    assert_equal(ip_address, record.traits.ip_address)
    assert_equal('74.209.16.0/20', record.traits.network)

    # This IP has MCC/MNC data.

    ip_address = '149.101.100.0'
    record = reader.enterprise(ip_address)

    assert_equal('310', record.traits.mobile_country_code)
    assert_equal('004', record.traits.mobile_network_code)

    reader.close
  end

  def test_isp
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-ISP-Test.mmdb',
    )
    ip = '1.128.1.1'
    record = reader.isp(ip)

    assert_equal(1221, record.autonomous_system_number)
    assert_equal('Telstra Pty Ltd', record.autonomous_system_organization)
    assert_equal('Telstra Internet', record.isp)
    assert_equal('Telstra Internet', record.organization)
    assert_equal(ip, record.ip_address)
    assert_equal('1.128.0.0/11', record.network)

    # This IP has MCC/MNC data.

    ip_address = '149.101.100.0'
    record = reader.isp(ip_address)

    assert_equal('310', record.mobile_country_code)
    assert_equal('004', record.mobile_network_code)

    reader.close
  end

  def test_no_traits
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Enterprise-Test.mmdb',
    )
    record = reader.enterprise('2.125.160.216')

    assert_equal('2.125.160.216', record.traits.ip_address)
    assert_equal('2.125.160.216/29', record.traits.network)
    assert_nil(record.traits.autonomous_system_number)
    assert_equal(false, record.traits.anonymous?)

    reader.close
  end

  def test_no_location
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Enterprise-Test.mmdb',
    )
    record = reader.enterprise('212.47.235.81')

    assert_nil(record.location.accuracy_radius)

    reader.close
  end

  def test_no_postal
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Enterprise-Test.mmdb',
    )
    record = reader.enterprise('212.47.235.81')

    assert_nil(record.postal.code)

    reader.close
  end

  def test_no_city
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Enterprise-Test.mmdb',
    )
    record = reader.enterprise('212.47.235.81')

    assert_nil(record.city.confidence)
    assert_nil(record.city.name)
    assert_nil(record.city.names)

    reader.close
  end

  def test_no_continent
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Enterprise-Test.mmdb',
    )
    record = reader.enterprise('212.47.235.81')

    assert_nil(record.continent.code)

    reader.close
  end

  def test_no_country
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Enterprise-Test.mmdb',
    )
    record = reader.enterprise('212.47.235.81')

    assert_nil(record.country.confidence)

    reader.close
  end

  def test_no_represented_country
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Enterprise-Test.mmdb',
    )
    record = reader.enterprise('212.47.235.81')

    assert_nil(record.represented_country.type)

    reader.close
  end

  def database_types
    [
      { 'file' => 'City', 'method' => 'city' },
      { 'file' => 'Country', 'method' => 'country' },
    ]
  end

  def test_default_locale
    database_types.each do |t|
      reader = MaxMind::GeoIP2::Reader.new(
        "test/data/test-data/GeoIP2-#{t['file']}-Test.mmdb",
      )
      record = reader.send(t['method'], '81.2.69.160')
      assert_equal('United Kingdom', record.country.name)
      reader.close
    end
  end

  def test_locale_list
    database_types.each do |t|
      reader = MaxMind::GeoIP2::Reader.new(
        "test/data/test-data/GeoIP2-#{t['file']}-Test.mmdb",
        %w[xx ru pt-BR es en],
      )
      record = reader.send(t['method'], '81.2.69.160')
      assert_equal('Великобритания', record.country.name)
      reader.close
    end
  end

  def test_has_ip_address_and_network
    database_types.each do |t|
      reader = MaxMind::GeoIP2::Reader.new(
        "test/data/test-data/GeoIP2-#{t['file']}-Test.mmdb",
      )
      record = reader.send(t['method'], '81.2.69.163')
      assert_equal('81.2.69.163', record.traits.ip_address)
      assert_equal('81.2.69.160/27', record.traits.network)
      reader.close
    end
  end

  def test_is_in_european_union
    database_types.each do |t|
      reader = MaxMind::GeoIP2::Reader.new(
        "test/data/test-data/GeoIP2-#{t['file']}-Test.mmdb",
      )
      record = reader.send(t['method'], '81.2.69.160')
      assert_equal(false, record.country.in_european_union?)
      assert_equal(false, record.registered_country.in_european_union?)
      reader.close
    end
  end

  def test_unknown_address
    database_types.each do |t|
      reader = MaxMind::GeoIP2::Reader.new(
        "test/data/test-data/GeoIP2-#{t['file']}-Test.mmdb",
      )
      error = assert_raises(
        MaxMind::GeoIP2::AddressNotFoundError,
      ) { reader.send(t['method'], '10.10.10.0') }
      assert_equal(
        'The address 10.10.10.0 is not in the database.',
        error.message,
      )
      reader.close
    end
  end

  def test_incorrect_database
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-City-Test.mmdb',
    )
    error = assert_raises(ArgumentError) { reader.country('10.10.10.10') }
    assert_equal(
      'The country method cannot be used with the GeoIP2-City database.',
      error.message,
    )
    reader.close
  end

  def test_invalid_address
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-City-Test.mmdb',
    )
    error = assert_raises(
      IPAddr::InvalidAddressError,
    ) { reader.city('invalid') }
    # Ruby 2.5 says just 'invalid address'. Ruby 2.6+ says 'invalid address:
    # invalid'.
    assert_match('invalid address', error.message)
    reader.close
  end

  def test_metadata
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-City-Test.mmdb',
    )
    assert_equal('GeoIP2-City', reader.metadata.database_type)
    reader.close
  end

  def test_constructor_with_minimum_keyword_arguments
    reader = MaxMind::GeoIP2::Reader.new(
      database: 'test/data/test-data/GeoIP2-Country-Test.mmdb',
    )
    record = reader.country('81.2.69.160')
    assert_equal('United Kingdom', record.country.name)
    reader.close
  end

  def test_constructor_with_all_keyword_arguments
    reader = MaxMind::GeoIP2::Reader.new(
      database: 'test/data/test-data/GeoIP2-Country-Test.mmdb',
      locales: %w[ru],
      mode: MaxMind::DB::MODE_MEMORY,
    )
    record = reader.country('81.2.69.160')
    assert_equal('Великобритания', record.country.name)
    reader.close
  end

  def test_constructor_missing_database
    error = assert_raises(ArgumentError) do
      MaxMind::GeoIP2::Reader.new
    end
    assert_equal('Invalid database parameter', error.message)

    error = assert_raises(ArgumentError) do
      MaxMind::GeoIP2::Reader.new(
        locales: %w[ru],
      )
    end
    assert_equal('Invalid database parameter', error.message)
  end

  def test_old_constructor_parameters
    reader = MaxMind::GeoIP2::Reader.new(
      'test/data/test-data/GeoIP2-Country-Test.mmdb',
      %w[ru],
      mode: MaxMind::DB::MODE_MEMORY,
    )
    record = reader.country('81.2.69.160')
    assert_equal('Великобритания', record.country.name)
    reader.close
  end
end
