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
                Section::make('Informasi Menu')
                    ->schema([
                        Grid::make(3)->schema([
                            TextInput::make('name')
                                ->label('Nama Menu')
                                ->required()
                                ->maxLength(255),
                            Select::make('location')
                                ->label('Lokasi Penempatan')
                                ->options([
                                    'header' => 'Header (Navigasi Atas)',
                                    'footer' => 'Footer (Bawah)',
                                    'sidebar' => 'Sidebar (Samping)',
                                ])
                                ->default('header')
                                ->required(),
                            Toggle::make('is_active')
                                ->label('Status Aktif')
                                ->default(true),
                        ]),
                    ]),

                Section::make('Daftar Item Menu')
                    ->schema([
                        Repeater::make('items')
                            ->relationship('items')
                            ->schema([
                                Grid::make(4)->schema([
                                    TextInput::make('label')
                                        ->label('Label')
                                        ->required(),
                                    Select::make('type')
                                        ->label('Tipe')
                                        ->options([
                                            'custom' => 'Custom URL',
                                            'page' => 'Halaman Statis',
                                            'category' => 'Kategori Post',
                                        ])
                                        ->default('custom'),
                                    TextInput::make('url')
                                        ->label('URL / Path')
                                        ->placeholder('/tentang-kami atau https://...'),
                                    Toggle::make('is_active')
                                        ->label('Aktif')
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
