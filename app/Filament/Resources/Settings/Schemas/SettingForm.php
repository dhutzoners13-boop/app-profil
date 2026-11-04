<?php

namespace App\Filament\Resources\Settings\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class SettingForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Konfigurasi Pengaturan')
                    ->schema([
                        Grid::make(3)->schema([
                            Select::make('group')
                                ->label('Kelompok Pengaturan')
                                ->options([
                                    'general' => 'Umum (Profil Instansi)',
                                    'contact' => 'Kontak & Alamat',
                                    'social' => 'Media Sosial',
                                    'api' => 'Integrasi / API',
                                ])
                                ->default('general')
                                ->required(),
                            TextInput::make('key')
                                ->label('Key Identitas')
                                ->required()
                                ->maxLength(255)
                                ->unique(ignoreRecord: true),
                            Select::make('type')
                                ->label('Tipe Nilai')
                                ->options([
                                    'text' => 'Teks Pendek',
                                    'textarea' => 'Teks Panjang',
                                    'image' => 'URL / Path Gambar',
                                    'boolean' => 'Boolean (Ya/Tidak)',
                                    'json' => 'Format JSON',
                                ])
                                ->default('text')
                                ->required(),
                        ]),
                        Textarea::make('value')
                            ->label('Nilai Pengaturan (Value)')
                            ->rows(4)
                            ->columnSpanFull(),
                    ]),
            ]);
    }
}
