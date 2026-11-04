<?php

namespace App\Filament\Resources\Media\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;
use Illuminate\Support\Facades\Auth;

class MediaForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Upload Media')
                    ->schema([
                        Hidden::make('user_id')
                            ->default(fn () => Auth::id()),
                        FileUpload::make('file_path')
                            ->label('Pilih File / Gambar')
                            ->disk('public')
                            ->directory('uploads')
                            ->visibility('public')
                            ->preserveFilenames()
                            ->storeFileNamesIn('file_name')
                            ->required(),
                        TextInput::make('alt_text')
                            ->label('Teks Alternatif (Alt Text)')
                            ->maxLength(255),
                    ]),
            ]);
    }
}
