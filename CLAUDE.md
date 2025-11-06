# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**GeoIP2-ruby** is MaxMind's official Ruby client library for:
- **GeoIP2/GeoLite2 Web Services**: Country, City, and Insights endpoints
- **GeoIP2/GeoLite2 Databases**: Local MMDB file reading for various database types (City, Country, ASN, Anonymous IP, Anonymous Plus, ISP, etc.)

The library provides both web service clients and database readers that return strongly-typed model objects containing geographic, ISP, anonymizer, and other IP-related data.

**Key Technologies:**
- Ruby 3.2+ (uses frozen string literals and modern Ruby features)
- MaxMind DB Reader for binary database files
- HTTP gem for web service client functionality
- Minitest for testing
- RuboCop with multiple plugins for code quality

## Code Architecture

### Package Structure

```
lib/maxmind/geoip2/
├── model/              # Response models (City, Insights, AnonymousIP, etc.)
├── record/             # Data records (City, Location, Traits, etc.)
├── client.rb           # HTTP client for MaxMind web services
├── reader.rb           # Local MMDB file reader
├── errors.rb           # Custom exceptions for error handling
└── version.rb          # Version constant
```

### Key Design Patterns

#### 1. **Attr Reader Pattern for Immutable Data**

Models expose data through `attr_reader` attributes that are initialized in the constructor. Unlike PHP's readonly properties, Ruby uses instance variables with attr_reader:

```ruby
class City < Country
  attr_reader :city
  attr_reader :location
  attr_reader :postal
  attr_reader :subdivisions

  def initialize(record, locales)
    super
    @city = MaxMind::GeoIP2::Record::City.new(record['city'], locales)
    @location = MaxMind::GeoIP2::Record::Location.new(record['location'])
    @postal = MaxMind::GeoIP2::Record::Postal.new(record['postal'])
    @subdivisions = create_subdivisions(record['subdivisions'], locales)
  end
end
```

**Key Points:**
- Instance variables are set in the constructor
- Use `attr_reader` to expose them
- Models and records are initialized from hash data (from JSON/DB)
- Records are composed objects (City contains City record, Location record, etc.)

#### 2. **Inheritance Hierarchies**

Models follow clear inheritance patterns:
- `Country` → base model with country/continent data
- `City` extends `Country` → adds city, location, postal, subdivisions
- `Insights` extends `City` → adds additional web service fields (web service only)
- `Enterprise` extends `City` → adds enterprise-specific fields

Records have similar patterns:
- `Abstract` → base with `get` method for accessing hash data
- `Place` extends `Abstract` → adds names/locales handling
- Specific records (`City`, `Country`, etc.) extend `Place` or `Abstract`

#### 3. **Get Method Pattern for Data Access**

Both models and records use a protected `get` method to safely access hash data:

```ruby
def get(key)
  if @record.nil? || !@record.key?(key)
    return false if key.start_with?('is_')
    return nil
  end

  @record[key]
end
```

- Returns `false` for missing boolean fields (starting with `is_`)
- Returns `nil` for missing optional fields
- Records store the raw hash in `@record` instance variable

Public methods expose data through the `get` method:

```ruby
def anonymizer_confidence
  get('anonymizer_confidence')
end

def provider_name
  get('provider_name')
end
```

#### 4. **Lazy Parsing for Special Types**

Some fields require parsing and are computed lazily:

```ruby
def network_last_seen
  return @network_last_seen if defined?(@network_last_seen)

  date_string = get('network_last_seen')

  if !date_string
    return nil
  end

  @network_last_seen = Date.parse(date_string)
end
```

- Use `defined?(@variable)` to check if already parsed
- Parse only once and cache in instance variable
- Handle nil cases before parsing

#### 5. **Web Service Only vs Database Models**

Some models are only used by web services and do **not** need MaxMind DB support:

**Web Service Only Models**:
- Models that are exclusive to web service responses
- Simpler implementation, just inherit and define in model hierarchy
- Example: `Insights` (extends City but used only for web service)

**Database-Supported Models**:
- Models used by both web services and database files
- Reader has specific methods (e.g., `anonymous_ip`, `anonymous_plus`, `city`)
- Must handle MaxMind DB format data structures
- Example: `City`, `Country`, `AnonymousIP`, `AnonymousPlus`

## Testing Conventions

### Running Tests

```bash
# Install dependencies
bundle install

# Run all tests
bundle exec rake test

# Run tests and RuboCop
bundle exec rake  # default task

# Run RuboCop only
bundle exec rake rubocop

# Run specific test file
ruby -Ilib:test test/test_reader.rb
```

### Test Structure

Tests are organized by functionality:
- `test/test_reader.rb` - Database reader tests
- `test/test_client.rb` - Web service client tests
- `test/test_model_*.rb` - Model-specific tests
- `test/data/` - Test fixtures and sample database files

### Test Patterns

Tests use Minitest with a constant for test data:

```ruby
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
    'traits' => {
      'ip_address' => '1.2.3.4',
      'prefix_length' => 24,
    },
  }.freeze

  def test_values
    model = MaxMind::GeoIP2::Model::Country.new(RAW, ['en'])

    assert_equal(42, model.continent.geoname_id)
    assert_equal('NA', model.continent.code)
    assert_equal('United States of America', model.country.name)
  end
end
```

When adding new fields to models:
1. Update the `RAW` constant to include the new field
2. Add assertions to verify the field is properly populated
3. Test both presence and absence of the field (nil handling)
4. Test with different values if applicable

## Working with This Codebase

### Adding New Fields to Existing Models

For database models (like AnonymousPlus):

1. **Add a public method** that calls `get`:
   ```ruby
   # A description of the field.
   #
   # @return [Type, nil]
   def field_name
     get('field_name')
   end
   ```

2. **For fields requiring parsing** (dates, complex types), use lazy loading:
   ```ruby
   def network_last_seen
     return @network_last_seen if defined?(@network_last_seen)

     date_string = get('network_last_seen')

     if !date_string
       return nil
     end

     @network_last_seen = Date.parse(date_string)
   end
   ```

For composed models (like City, Country):

1. **Add `attr_reader`** for the new record/field:
   ```ruby
   attr_reader :new_field
   ```

2. **Initialize in constructor**:
   ```ruby
   def initialize(record, locales)
     super
     @new_field = record['new_field']
   end
   ```

3. **Provide comprehensive YARD documentation** (`@return` tags)
4. **Update tests** to include the new field in test data and assertions
5. **Update CHANGELOG.md** with the change

### Adding New Models

When creating a new model class:

1. **Determine if web service only or database-supported**
2. **Follow the pattern** from existing similar models
3. **Extend the appropriate base class** (e.g., `Country`, `City`, or standalone)
4. **Use `attr_reader`** for composed record objects
5. **Provide comprehensive YARD documentation** for all public methods
6. **Add corresponding tests** with full coverage
7. **If database-supported**, add a method to `Reader` class

### Deprecation Guidelines

When deprecating fields:

1. **Use `@deprecated` in YARD doc** with version and alternative:
   ```ruby
   # This field is deprecated as of version 2.0.0.
   # Use the anonymizer object from the Insights response instead.
   #
   # @return [Boolean]
   # @deprecated since 2.0.0
   def is_anonymous
     get('is_anonymous')
   end
   ```

2. **Keep deprecated fields functional** - don't break existing code
3. **Update CHANGELOG.md** with deprecation notices
4. **Document alternatives** in the deprecation message

### CHANGELOG.md Format

Always update `CHANGELOG.md` for user-facing changes.

**Important**: Do not add a date to changelog entries until release time.

- If there's an existing version entry without a date (e.g., `1.5.0`), add your changes there
- If creating a new version entry, don't include a date - it will be added at release time
- Use past tense for descriptions

```markdown
## 1.5.0

* A new `field_name` method has been added to `MaxMind::GeoIP2::Model::ModelName`.
  This method provides information about...
* The `old_field` method in `MaxMind::GeoIP2::Model::ModelName` has been deprecated.
  Please use `new_field` instead.
```

## Common Pitfalls and Solutions

### Problem: Incorrect Nil Handling

Using the wrong nil check can cause unexpected behavior.

**Solution**: Follow these patterns:
- Use `if !variable` or `if variable.nil?` to check for nil
- The `get` method returns `nil` for missing keys (except `is_*` keys which return `false`)
- Use `defined?(@variable)` to check if an instance variable has been set (for lazy loading)

### Problem: Missing YARD Documentation

New methods without documentation make the API harder to use.

**Solution**: Always add YARD documentation:
- Use `@return [Type, nil]` for the return type
- Add a description of what the method returns
- Use `@deprecated since X.Y.Z` for deprecated methods
- Include examples in model class documentation if helpful

### Problem: Test Failures After Adding Fields

Tests fail because fixtures don't include new fields.

**Solution**: Update all related tests:
1. Add field to test `RAW` constant or test data hash
2. Add assertions for the new field
3. Test nil case if field is optional
4. Test different data types if applicable

## Code Style Requirements

- **RuboCop enforced** with multiple plugins (minitest, performance, rake, thread_safety)
- **Frozen string literals** (`# frozen_string_literal: true`) in all files
- **Target Ruby 3.2+**
- **No metrics cops** - AbcSize, ClassLength, MethodLength disabled
- **Trailing commas allowed** in arrays, hashes, and arguments
- **Use `if !condition`** instead of `unless condition` (NegatedIf disabled)

Key RuboCop configurations:
- Line length not enforced
- Format string token checks disabled
- Numeric predicates allowed in any style
- Multiple assertions allowed in tests

## Development Workflow

### Setup
```bash
bundle install
```

### Before Committing
```bash
# Run tests and linting
bundle exec rake

# Or run separately
bundle exec rake test
bundle exec rake rubocop
```

### Running Single Test
```bash
ruby -Ilib:test test/test_reader.rb
```

### Version Requirements
- **Ruby 3.2+** required
- Target compatibility should match current supported Ruby versions (3.2-3.4)

## Additional Resources

- [API Documentation](https://www.rubydoc.info/gems/maxmind-geoip2)
- [GeoIP2 Web Services Docs](https://dev.maxmind.com/geoip/docs/web-services)
- [MaxMind DB Format](https://maxmind.github.io/MaxMind-DB/)
- GitHub Issues: https://github.com/maxmind/GeoIP2-ruby/issues
