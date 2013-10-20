module Guard
  class Ecukes

    # The inspector verifies of the changed paths are valid
    # for Guard::Ecukes.
    #
    module Inspector
      class << self

        # Clean the changed paths and return only valid
        # Ecukes features.
        #
        # @param [Array<String>] paths the changed paths
        # @return [Array<String>] the valid feature files
        #
        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| ecukes_file?(p) || ecukes_folder?(p) }
          paths = paths.delete_if { |p| included_in_other_path?(p, paths) }
          clear_ecukes_files_list
          paths
        end

        private

        # Tests if the file is the features folder.
        #
        # @param [String] path the file
        # @return [Boolean] when the file is the feature folder
        #
        def ecukes_folder?(path)
          path.match(/^\/?features/) && !path.match(/\..+$/)
        end

        # Tests if the file is valid.
        #
        # @param [String] path the file
        # @return [Boolean] when the file valid
        #
        def ecukes_file?(path)
          ecukes_files.include?(path.split(':').first)
        end

        # Scans the project and keeps a list of all
        # feature files in the `features` directory.
        #
        # @see #clear_jasmine_specs
        # @return [Array<String>] the valid files
        #
        def ecukes_files
          @ecukes_files ||= Dir.glob("features/**/*.feature")
        end

        # Clears the list of features in this project.
        #
        def clear_ecukes_files_list
          @ecukes_files = nil
        end

        # Checks if the given path is already contained
        # in the paths list.
        #
        # @param [Sting] path the path to test
        # @param [Array<String>] paths the list of paths
        #
        def included_in_other_path?(path, paths)
          paths = paths.select { |p| p != path }
          massaged = path[0...(path.index(':') || path.size)]
          paths.any? { |p| (path.include?(p) && (path.gsub(p, '')).include?('/')) || massaged.include?(p) }
        end
      end
    end
  end
end
