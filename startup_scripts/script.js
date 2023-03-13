// priority: 0

console.info('Baking the protane')

StartupEvents.registry('item', event => {
	// Register new items here
	event.create('protane_shard')
		.displayName('Protane')
		.texture('protane:item/protane_shard')
		.glow(true);
	event.create('protane_spheriod')
		.displayName('Protane Spheroid')
		.texture('protane:item/protane')
		.maxStackSize(1)
		.glow(true);
	event.create('protane_ingot')
		.displayName('Protane Ingot')
		.texture('protane:item/protane_ingot')
		.glow(true);
	event.create('protane_crystal')
		.displayName('Protane Crystal')
		.maxStackSize(4)
		.texture('protane:item/protane_crystal')
		.glow(true)
		.food(food => {
			food
				.effect('wither', 600, 4, 8)
				.alwaysEdible()
				.eaten(ctx => {
					ctx.player.tell(Text.red('You feel the protane flowing into you...'))
					ctx.player.addXP(3 * 9 * 9 * 9 + 3 * 10)
				})
		});
	event.create('protane_tube')
		.displayName('Protane Tube')
		.unstackable()
		.texture('protane:item/protane_tube')
	event.create('neutran_tube')
		.displayName('Neutran Tube')
		.unstackable()
		.texture('protane:item/neutran_tube');
	event.create('alabaster_tube')
		.displayName('Alabaster Tube')
		.texture('protane:item/alabaster_tube');
})

// Setup recipes
ServerEvents.recipes(event => {
	// Create protane tubes
	event.smithing('kubejs:protane_tube', 'kubejs:alabaster_tube', 'kubejs:protane_crystal');
	// Create alabaster tubes for base
	event.shaped('kubejs:alabaster_tube', [
		'GGG',
		'GCG',
		'III'
	], {
		C: 'minecraft:chiseled_quartz_block',
		I: '#forge:ingots/iron',
		G: '#forge:glass'
	})
	event.shaped('kubejs:protane_crystal', [
		'III',
		'III',
		'III'
	], {
		I: 'kubejs:protane_ingot',
	})
	event.shaped('kubejs:protane_ingot', [
		'SSS',
		'SSS',
		'SSS'
	], {
		S: 'kubejs:protane_shard',
	})
	event.shaped('kubejs:protane_ingot', [
		'SSS',
		'SSS',
		'SSS'
	], {
		S: 'kubejs:protane_shard',
	})
	event.shaped('kubejs:protane_shard', [
		'EEE',
		'EEE',
		'EEE'
	], {
		E: 'create_sa:heap_of_experience',
	})
	// Refine the protane
	// event.smelting('16x kubejs:protane_ingot', 'kubejs:protane_crystal')
	// Super charge the nuggets
	// event.shapeless('kubejs:protane_shard', [
	// 	Item.of('kubejs:protane_tube'),
	// 	'create:experience_nugget'
	// ])
	// 	.damageIngredient(Item.of('kubejs:protane_tube'));
})

StartupEvents.registry('block', event => {
	// Register new blocks here
	// event.create('example_block').material('wood').hardness(1.0).displayName('Example Block')
})

ItemEvents.toolTierRegistry(event => {
	event.add('protane_tier', tier => {
		tier.uses = 1024
		tier.speed = 16.0
		tier.attackDamageBonus = 8.0
		tier.level = 8
		tier.enchantmentValue = 32
		tier.repairIngredient = 'kubejs:protane_ingot'
	})
})

ItemEvents.armorTierRegistry(event => {
	event.add('protane_tier', tier => {
		tier.durabilityMultiplier = 32 // Each slot will be multiplied with [13, 15, 16, 11]
		tier.slotProtections = [2, 5, 6, 2] // Slot indicies are [FEET, LEGS, BODY, HEAD] 
		tier.enchantmentValue = 64
		tier.equipSound = 'minecraft:item.armor.equip_iron'
		tier.repairIngredient = 'kubejs:protane_ingot'
		tier.toughness = 5.0 // diamond has 2.0, netherite 3.0
		tier.knockbackResistance = 2.0
	})
})

// events.listen('player.chat', (event) => {
// 	if (event.message.trim().equalsIgnoreCase('cristal')) {
// 		// Schedule task in 1 tick, because if you reply immidiently, it will print before player's message
// 		event.server.scheduleInTicks(1, event.server, (callback) => {
// 			callback.data.tell(text.gray('Hay palabras que no deberían decirse en voz alta...'))
// 		})
// 	} else if (event.message.trim().equalsIgnoreCase('glass')) {
// 		// Schedule task in 1 tick, because if you reply immidiently, it will print before player's message
// 		event.server.scheduleInTicks(1, event.server, (callback) => {
// 			callback.data.tell(text.gray('There are words that shouldn\'t be told out loud...'))
// 		})
// 	}
// })
