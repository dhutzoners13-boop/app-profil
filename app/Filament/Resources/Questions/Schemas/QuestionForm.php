<?php

namespace App\Filament\Resources\Questions\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class QuestionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Identitas Penanya')
                    ->schema([
                        Grid::make(3)->schema([
                            TextInput::make('name')
                                ->label('Nama Lengkap')
                                ->required()
                                ->maxLength(255),
                            TextInput::make('email')
                                ->label('Email')
                                ->email()
                                ->required()
                                ->maxLength(255),
                            TextInput::make('phone')
                                ->label('No. Telepon / WhatsApp')
                                ->tel()
                                ->maxLength(50),
                        ]),
                    ]),

                Section::make('Detail Pertanyaan')
                    ->schema([
                        Grid::make(2)->schema([
                            Select::make('topic_id')
                                ->label('Topik / Kategori')
                                ->relationship('topic', 'name')
                                ->searchable()
                                ->preload()
                                ->required(),
                            Select::make('status')
                                ->label('Status Pertanyaan')
                                ->options([
                                    'pending' => 'Menunggu Respon',
                                    'answered' => 'Sudah Dijawab',
                                    'rejected' => 'Ditolak / Tidak Sesuai',
                                ])
                                ->default('pending')
                                ->required(),
                        ]),
                        TextInput::make('subject')
                            ->label('Judul / Subjek')
                            ->required()
                            ->maxLength(255),
                        Textarea::make('body')
                            ->label('Isi Pertanyaan')
                            ->rows(5)
                            ->required()
                            ->columnSpanFull(),
                        TextInput::make('ip_address')
                            ->label('IP Address')
                            ->disabled()
                            ->dehydrated(false),
                    ]),
            ]);
    }
}
