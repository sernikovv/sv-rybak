add this to ox_inventory:

```lua
	['wedka'] = {
        label = 'Wędka',
        weight = 10,
        stack = false,
        close = true,
		client = {
			export = 'sv-rybak.wedka'
		}
    },

	['fish_sum'] = {
		label = 'Sum',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['fish_okon'] = {
		label = 'Okoń',
		weight = 30,
		stack = true,
		close = true,
		description = nil
	},

	['fish_mintaj'] = {
		label = 'Mintaj',
		weight = 40,
		stack = true,
		close = true,
		description = nil
	},

	['fish_losos'] = {
		label = 'Łosoś',
		weight = 40,
		stack = true,
		close = true,
		description = nil
	},

	['fish_szczupak'] = {
		label = 'Szczupak',
		weight = 40,
		stack = true,
		close = true,
		description = nil
	},

	['fish_jesiotr'] = {
		label = 'Jesiotr',
		weight = 40,
		stack = true,
		close = true,
		description = nil
	},
```