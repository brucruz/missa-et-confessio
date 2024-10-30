Geocoder.configure(
  # Geocoding options
  # timeout: 3,                 # geocoding service timeout (secs)
  lookup: Rails.env.test? ? :test : :google,         # name of geocoding service (symbol)
  # ip_lookup: :ipinfo_io,      # name of IP address geocoding service (symbol)
  # language: :en,              # ISO-639 language code
  # use_https: false,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  # api_key: nil,               # API key for geocoding service
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #del)
  google: {
    api_key: Rails.application.credentials.google_maps_api_key,
    timeout: 3
  },
  google_places_search: {
    api_key: Rails.application.credentials.google_maps_api_key,
    timeout: 3
    # fields: %w[]
    # locationbias: "point:-36.8509,174.7645"
  }

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear

  # Cache configuration
  # cache_options: {
  #   expiration: 2.days,
  #   prefix: 'geocoder:'
  # }
)
