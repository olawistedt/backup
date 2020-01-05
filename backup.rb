require 'fileutils'

start = Time.now

destination = __dir__ + start.strftime("%Y-%m-%d")
FileUtils.rm_rf destination
FileUtils.mkdir_p destination

#
# Copying these directories
#

# Copies files and directory trees.

# XCOPY source [destination] [/A | /M] [/D[:date]] [/P] [/S [/E]] [/V] [/W]
#                            [/C] [/I] [/Q] [/F] [/L] [/G] [/H] [/R] [/T] [/U]
#                            [/K] [/N] [/O] [/X] [/Y] [/-Y] [/Z] [/B] [/J]
#                            [/EXCLUDE:file1[+file2][+file3]...]

#   source       Specifies the file(s) to copy.
#   destination  Specifies the location and/or name of new files.
#   /A           Copies only files with the archive attribute set,
#                doesn't change the attribute.
#   /M           Copies only files with the archive attribute set,
#                turns off the archive attribute.
#   /D:m-d-y     Copies files changed on or after the specified date.
#                If no date is given, copies only those files whose
#                source time is newer than the destination time.
#   /EXCLUDE:file1[+file2][+file3]...
#                Specifies a list of files containing strings.  Each string
#                should be in a separate line in the files.  When any of the
#                strings match any part of the absolute path of the file to be
#                copied, that file will be excluded from being copied.  For
#                example, specifying a string like \obj\ or .obj will exclude
#                all files underneath the directory obj or all files with the
#                .obj extension respectively.
#   /P           Prompts you before creating each destination file.
#   /S           Copies directories and subdirectories except empty ones.
#   /E           Copies directories and subdirectories, including empty ones.
#                Same as /S /E. May be used to modify /T.
#   /V           Verifies the size of each new file.
#   /W           Prompts you to press a key before copying.
#   /C           Continues copying even if errors occur.
#   /I           If destination does not exist and copying more than one file,
#                assumes that destination must be a directory.
#   /Q           Does not display file names while copying.
#   /F           Displays full source and destination file names while copying.
#   /L           Displays files that would be copied.
#   /G           Allows the copying of encrypted files to destination that does
#                not support encryption.
#   /H           Copies hidden and system files also.
#   /R           Overwrites read-only files.
#   /T           Creates directory structure, but does not copy files. Does not
#                include empty directories or subdirectories. /T /E includes
#                empty directories and subdirectories.
#   /U           Copies only files that already exist in destination.
#   /K           Copies attributes. Normal Xcopy will reset read-only attributes.
#   /N           Copies using the generated short names.
#   /O           Copies file ownership and ACL information.
#   /X           Copies file audit settings (implies /O).
#   /Y           Suppresses prompting to confirm you want to overwrite an
#                existing destination file.
#   /-Y          Causes prompting to confirm you want to overwrite an
#                existing destination file.
#   /Z           Copies networked files in restartable mode.
#   /B           Copies the Symbolic Link itself versus the target of the link.
#   /J           Copies using unbuffered I/O. Recommended for very large files.

# The switch /Y may be preset in the COPYCMD environment variable.
# This may be overridden with /-Y on the command line.

def copy_using_tool(method, directories, dst)
    directories.each do | source |
        source.gsub!("/", "\\")
        s = source.split("\\")
        destination = dst + "\\" + s[s.length-1]
        destination.gsub!("/", "\\")
        puts source
        puts destination
        case method
        when :xcopy
            puts "Copy using XCOPY"
            out = %x"XCOPY /E /V /I /F /R /G /H /K /C /Y /B /J #{source} #{destination}"
            puts out
#         if $?.exitstatus != 0
#             puts "XCOPY went wrong"
#             a = out.split("\n")
#             puts a[a.length-1]
#             exit 0
#         end
        when :robocopy
            puts "Copy using ROBOCOPY"
            out = %x"ROBOCOPY #{source} #{destination}"
            puts out
        when :fileutils
            puts "Copy using Ruby FileUtils"
            FileUtils.cp_r source, destination
        end
    end
end

sources = ["c:/Users/ola", "d:/Dropbox", "d:/OneDrive", "d:/xampp"]

#copy_using_tool(:xcopy, sources, destination)
copy_using_tool(:robocopy, sources, destination)
#copy_using_tool(:fileutils, sources, destination)

finish = Time.now
diff = finish - start
puts "Took " + diff.to_s + " seconds."
