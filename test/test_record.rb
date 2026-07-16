# frozen_string_literal: true

require 'date'
require 'maxmind/geoip2'
require 'minitest/autorun'

class RecordTest < Minitest::Test
  # This covers the common case where a web service response has no
  # "anonymizer" key at all. Insights#initialize always calls
  # Anonymizer.new(record['anonymizer']), so this exercises
  # Anonymizer.new(nil) and, in turn, AnonymizerFeed.new(nil).
  def test_insights_no_anonymizer
    model = MaxMind::GeoIP2::Model::Insights.new({}, ['en'])

    assert_nil(model.anonymizer.confidence)
    refute(model.anonymizer.anonymous?)
    refute(model.anonymizer.anonymous_vpn?)
    refute(model.anonymizer.hosting_provider?)
    refute(model.anonymizer.public_proxy?)
    refute(model.anonymizer.residential_proxy?)
    refute(model.anonymizer.tor_exit_node?)
    assert_nil(model.anonymizer.network_last_seen)
    assert_nil(model.anonymizer.provider_name)

    assert_nil(model.anonymizer.residential.confidence)
    assert_nil(model.anonymizer.residential.network_last_seen)
    assert_nil(model.anonymizer.residential.provider_name)
  end

  # This covers an "anonymizer" object being present without a nested
  # "residential" key, which is the common case when the network is not
  # part of the residential proxy feed.
  def test_insights_anonymizer_without_residential
    model = MaxMind::GeoIP2::Model::Insights.new(
      {
        'anonymizer' => {
          'confidence' => 85,
        },
      },
      ['en'],
    )

    assert_equal(85, model.anonymizer.confidence)

    assert_nil(model.anonymizer.residential.confidence)
    assert_nil(model.anonymizer.residential.network_last_seen)
    assert_nil(model.anonymizer.residential.provider_name)
  end

  # network_last_seen is parsed lazily and guards against a missing date
  # string. This asserts the guard is in place rather than an unconditional
  # Date.parse(nil), which would raise.
  def test_anonymizer_feed_network_last_seen_absent
    feed = MaxMind::GeoIP2::Record::AnonymizerFeed.new(
      { 'confidence' => 82 },
    )

    assert_nil(feed.network_last_seen)
  end

  def test_anonymizer_network_last_seen_absent
    anonymizer = MaxMind::GeoIP2::Record::Anonymizer.new(
      { 'confidence' => 85 },
    )

    assert_nil(anonymizer.network_last_seen)
  end

  def test_anonymous_plus_network_last_seen_absent
    model = MaxMind::GeoIP2::Model::AnonymousPlus.new(
      {
        'ip_address' => '1.2.3.4',
        'prefix_length' => 24,
      },
    )

    assert_nil(model.network_last_seen)
  end
end
