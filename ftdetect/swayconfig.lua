vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    -- Match config files anywhere under a sway/ or .sway/ directory tree.
    -- Covers split configs (keymaps.conf, outputs.conf) and bare config files,
    -- both at the deployed path (~/.config/sway/) and in dotfiles source trees
    -- where sway/ may not be the direct parent (e.g. modules/sway/src/).
    pattern = {
        '**/{,.}sway/config',
        '**/{,.}sway/**/config',
        '**/{,.}sway/*.conf',
        '**/{,.}sway/**/*.conf',
    },
    callback = function(args)
        -- Require sway/ or .sway/ as an actual path component.
        if not args.file:match('/%.?sway/') then return end
        if args.file:match('sway%-portals%.conf$') then return end

        vim.bo.filetype = 'swayconfig'
    end
})
