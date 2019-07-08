module Intermix
  class Vacuum
    DEFAULT_STATS_OFF_THRESHOLD = 0.10
    DEFAULT_UNSORTED_THRESHOLD  = 0.10

    REDSHIFT_USERNAME = ''
    REDSHIFT_HOST     = ''
    REDSHIFT_PORT     = 5439

    IGNORED_SCHEMAS = %w(pg_internal)

    attr_reader :client,
                :full, :delete_only, :sort, :analyze,
                :stats_off_threshold, :unsorted_threshold,
                :admin_user, :host, :port

    def initialize(client:,
                   delete_only: false, full: false, sort: false,
                   stats_off_threshold: DEFAULT_STATS_OFF_THRESHOLD, unsorted_threshold: DEFAULT_UNSORTED_THRESHOLD,
                   admin_user: REDSHIFT_USERNAME, host: REDSHIFT_HOST, port: REDSHIFT_PORT)
      raise ArgumentError, 'client cannot be nil.' unless client.present?
      raise ArgumentError, 'invalid vacuum mode.' if full && [delete_only, sort].any?

      @client = client

      @full        = full
      @delete_only = delete_only
      @sort        = sort
      @analyze     = true if full || delete_only

      @stats_off_threshold = stats_off_threshold
      @unsorted_threshold  = unsorted_threshold

      @admin_user = admin_user
      @host       = host
      @port       = port
    end

    def generate_script
      selected_tables = client.tables.select do |table|
        if IGNORED_SCHEMAS.include?(table.schema_name)
          false
        elsif table.stats_pct_off.nil?
          false
        elsif table.size_pct_unsorted.nil?
          false
        elsif table.stats_pct_off <= @stats_off_threshold
          false
        elsif table.size_pct_unsorted <= @unsorted_threshold
          false
        else
          true
        end
      end

      output = script_header

      selected_tables.group_by(&:db_name).each do |db_name, tables|
        output += "\n\\c #{db_name}\n\n"
        tables.sort_by { |table| -table.size_pct_unsorted }.each do |table|
          output += vacuum_command(table: table, full: @full, delete_only: @delete_only, sort: @sort)
          output += analyze_command(table: table) if @analyze
          output += "\n"
        end
      end

      output += "\n"

      output
    end

    def save_script(location = 'output/vacuum_scripts/vacuum_databases.sh')
      File.open(location, 'w') { |file| file.write(generate_script) }
    end

    private

    def script_header
      <<~SCRIPT
        #!/bin/bash
        # Intermix.io Vacuum Script
        #
        # This script requires the psql postgres command line client be installed prior
        # to running.  The psql client is avaliable for download here,
        # https://www.postgresql.org/download/.
        #
        #
        # You will be prompted for the administrator password
        # Override the administrator username here
        adminuser="#{@admin_user}"
        psqlcommand="psql -e"
        # Don't edit anything beyond this point
        logindb="dev"
        redshiftport="#{@host}"
        redshifthost="#{@port}"
        ${{psqlcommand}} -d ${{logindb}} -U ${{adminuser}} -p ${{redshiftport}} -h ${{redshifthost}} <<EOF
      SCRIPT
    end

    def vacuum_command(table:, full:, delete_only:, sort:)
      command = if full
        'FULL'
      elsif delete_only
        'DELETE ONLY'
      elsif sort
        table.sort_key == 'INTERLEAVED' ? 'REINDEX' : 'SORT ONLY'
      end

      "VACUUM #{command} #{table.full_name}\n"
    end

    def analyze_command(table:)
      "ANALYZE #{table.full_name};\n"
    end
  end
end
