workspace "Openglad"
   configurations { "Debug", "Release" }

newoption {
	trigger     = "cflags",
	value       = "FLAGS",
	description = "Flags passed directly to the compiler."
}
newoption {
	trigger     = "ldflags",
	value       = "FLAGS",
	description = "Flags passed directly to the linker."
}
newoption {
	trigger     = "includedirs",
	value       = "DIR",
	description = "Directories to add to the include path."
}
newoption {
	trigger     = "libdirs",
	value       = "DIR",
	description = "Directories to add to the linker lib path."
}
   
project "openglad"
	kind "ConsoleApp"
	language "C++"
	files { 
		"src/**.h", 
		"src/**.cpp", 
		"src/**.c", 
		"util/savepng.*" 
	}
	excludes { 
		"src/purchasing.*", 
		"src/OuyaController.*" 
	}
	
	-- Messy, but premake doesn't let you re-add excluded files.  TODO: Manage a lua list instead.
	excludes { 
		"src/external/physfs/archivers/grp.c", 
		"src/external/physfs/archivers/hog.c", 
		"src/external/physfs/archivers/lzma.c", 
		"src/external/physfs/archivers/mvl.c", 
		"src/external/physfs/archivers/qpak.c", 
		"src/external/physfs/archivers/wad.c", 
		"src/external/physfs/extras/PhysDS.NET/**", 
		"src/external/physfs/extras/physfs_rb/**", 
		"src/external/physfs/extras/abs-file.h", 
		"src/external/physfs/extras/globbing.c", 
		"src/external/physfs/extras/globbing.h", 
		"src/external/physfs/extras/ignorecase.c", 
		"src/external/physfs/extras/ignorecase.h", 
		"src/external/physfs/extras/physfshttpd.c", 
		"src/external/physfs/extras/physfsunpack.c", 
		"src/external/physfs/extras/selfextract.c" 
	}
	
	defines { "PHYSFS_SUPPORTS_ZIP", "TARGET_API_MAC_OSX=1" }
	--   buildoptions { "-std=gnu++0x" }

	-- SDL2 + PNG
	links { "SDL2main", "SDL2", "SDL2_mixer", "png" }

	-- Include and lib search paths (cover both Intel and Apple Silicon Homebrew)
	includedirs { 
		"src/external/**", 
		"/opt/homebrew/include/SDL2", "/opt/homebrew/include",
		"/usr/local/include/SDL2", "/usr/local/include" 
	}
	libdirs { 
		"/opt/homebrew/lib",
		"/usr/local/lib" 
	}

	-- Add this for modern macOS code path in PhysFS (avoids MP* legacy code)
	defines { "TARGET_API_MAC_OSX=1" }

	-- macOS frameworks needed by SDL2 paths & your code
    -- (Premake 5 accepts ".framework" entries in links on macOS)
	links { 
		-- "Cocoa.framework",
		"IOKit.framework",
		-- "CoreVideo.framework", 
		"CoreFoundation.framework", 
		"CoreServices.framework"
	}

	-- Pass through user-supplied flags
    if _OPTIONS["cflags"] then
        buildoptions( string.explode(_OPTIONS["cflags"], " ") )
    end
    if _OPTIONS["ldflags"] then
        linkoptions( string.explode(_OPTIONS["ldflags"], " ") )
    end
    if _OPTIONS["includedirs"] then
        includedirs( string.explode(_OPTIONS["includedirs"], " ") )
    end
    if _OPTIONS["libdirs"] then
        libdirs( string.explode(_OPTIONS["libdirs"], " ") )
    end

	-- Apply C-specific flags
--   filter "files:src/**.c"
--     language "C"
--     buildoptions { "-std=c99" } -- or -std=c11 if needed

	-- Apply C++-specific flags
--   filter "files:src/**.cpp"
--     language "C++"
--     buildoptions { "-std=c++11" } -- Replaces gnu++0x
	filter "configurations:Debug"
		defines { "DEBUG" }
		symbols "On"

	filter "configurations:Release"
		defines { "NDEBUG" }
		optimize "On"
		kind "WindowedApp" -- if you want a GUI app in Release on macOS

	-- Clear filters
    filter {}
		