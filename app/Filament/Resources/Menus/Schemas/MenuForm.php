<?php

namespace App\Filament\Resources\Menus\Schemas;

use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class MenuForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Menu Information'))
                    ->schema([
                        Grid::make(3)->schema([
                            TextInput::make('name')
                                ->label(__('Menu Name'))
                                ->required()
                                ->maxLength(255),
                            Select::make('location')
                                ->label(__('Placement Location'))
                                ->options([
                                    'header' => __('Header (Top Navigation)'),
                                    'footer' => __('Footer (Bottom)'),
                                    'sidebar' => __('Sidebar (Side)'),
                                ])
                                ->default('header')
                                ->required(),
                            Toggle::make('is_active')
                                ->label(__('Active Status'))
                                ->default(true),
                        ]),
                    ]),

                Section::make(__('Menu Items List'))
                    ->schema([
                        Repeater::make('items')
                            ->relationship('items')
                            ->schema([
                                Grid::make(4)->schema([
                                    TextInput::make('label')
                                        ->label(__('Label'))
                                        ->required(),
                                    Select::make('type')
                                        ->label(__('Type'))
                                        ->options([
                                            'custom' => __('Custom URL'),
                                            'page' => __('Static Page'),
                                            'category' => __('Post Category'),
                                        ])
                                        ->default('custom'),
                                    TextInput::make('url')
                                        ->label(__('URL / Path'))
                                        ->placeholder('/tentang-kami atau https://...'),
                                    Toggle::make('is_active')
                                        ->label(__('Active'))
                                        ->default(true),
                                ]),
                            ])
                            ->orderColumn('sort_order')
                            ->collapsible()
                            ->itemLabel(fn (array $state): ?string => $state['label'] ?? null)
                            ->columnSpanFull(),
                    ]),
            ]);
    }
}
