# name: Gentoo Proselyte
# author: W. Mark Kubacki <wmark@hurrikane.de>

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1

set -g __fish_git_prompt_color_branch magenta --bold
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""

set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green --bold

function fish_prompt --description "Write out the prompt"

	set -l last_status $status

	# Just calculate these once, to save a few cycles when displaying the prompt
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
	end

	if not set -q __fish_prompt_normal
		set -g __fish_prompt_normal (set_color normal)
	end

	if not set -q __fish_color_keydesc
		set -g __fish_color_keydesc (set_color 007755)
	end

	if not set -q __fish_color_hostname
		set -g __fish_color_hostname (set_color ffffff)
	end

	echo -n -s "$USER" @ "$__fish_color_hostname" "$__fish_prompt_hostname"

	# remind of jobs
	set -l pending_jobs (count (builtin jobs -p))
	if test $pending_jobs -gt 0
		echo -n -s ' ' "$__fish_color_keydesc" "jobs:" "$__fish_prompt_normal" $pending_jobs
	end

	# show virtual env
	if set -q VIRTUAL_ENV
		echo -n -s ' ' "$__fish_color_keydesc" "env:" "$__fish_prompt_normal" (basename "$VIRTUAL_ENV")
	end

	# details on GIT
	printf '%s ' (__fish_git_prompt)

	switch $USER

		case root

		if not set -q __fish_prompt_cwd
			if set -q fish_color_cwd_root
				set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
			else
				set -g __fish_prompt_cwd (set_color $fish_color_cwd)
			end
		end

		case '*'

		if not set -q __fish_prompt_cwd
			set -g __fish_prompt_cwd (set_color $fish_color_cwd)
		end

	end

	echo -n -s "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal"

	# last command
	if set -q CMD_DURATION
		echo -n -s ' ' "$__fish_color_keydesc" "t:" "$__fish_prompt_normal" $CMD_DURATION
	end

	if not test $last_status -eq 0
		set_color $fish_color_error
	end

	echo -n -s ' # '

end

function dir
	ls -l --all --human-readable $argv
end
