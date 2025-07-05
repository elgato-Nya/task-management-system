<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create users
        $users = User::factory(5)->create();

        // Create a specific test user
        $testUser = User::factory()->create([
            'name' => 'John Doe',
            'email' => 'john@example.com',
        ]);

        // Create tasks and assign them to existing users
        \App\Models\Task::factory(20)->create([
            'user_id' => $users->random()->id,
        ]);

        // Create some tasks for the test user
        \App\Models\Task::factory(5)->create([
            'user_id' => $testUser->id,
        ]);
    }
}
