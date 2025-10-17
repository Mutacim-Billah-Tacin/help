-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- nvim-dap
--local map = vim.keymap.set

-- All maps are now perfectly aligned with LazyVim's official documentation!

-- Start/Continue (c)
--map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "DAP: Run/Continue" })

-- Step Over (0 - Zero) -- CHANGE
--map("n", "<leader>d0", "<cmd>lua require'dap'.step_over()<CR>", { desc = "DAP: Step Over" })

-- Step Into (I - Capital 'i') -- CHANGE
--map("n", "<leader>dI", "<cmd>lua require'dap'.step_into()<CR>", { desc = "DAP: Step Into" })

-- Step Out (o - Lowercase 'o')
--map("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "DAP: Step Out" })

-- Toggle Breakpoint (b)
--map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "DAP: Toggle Breakpoint" })

-- Conditional Breakpoint (B)
--map(
--  "n",
--  "<leader>dB",
--  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
--  { desc = "DAP: Conditional Breakpoint" }
--)

-- Open REPL (r)
--map("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "DAP: Open REPL" })

-- Run Last Debugging Session (l)
--map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "DAP: Run Last Debugging Session" })

-- dap-ui toggle (w - Widgets) -- CHANGE
--map("n", "<leader>dw", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "DAP: Toggle Debug UI" })
