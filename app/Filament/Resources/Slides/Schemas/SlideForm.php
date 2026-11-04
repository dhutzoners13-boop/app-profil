<?php

namespace App\Filament\Resources\Slides\Schemas;

use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class SlideForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Slide Information'))
                    ->schema([
                        Grid::make(2)->schema([
                            TextInput::make('title')
                                ->label(__('Slide Title'))
                                ->required()
                                ->maxLength(255),
                            TextInput::make('link_url')
                                ->label(__('Target URL (Click Link)'))
                                ->placeholder('https://...'),
                        ]),
                        Textarea::make('description')
                            ->label(__('Short Description'))
                            ->rows(3)
                            ->columnSpanFull(),
                        FileUpload::make('image')
                            ->label(__('Slide Image (Banner)'))
                            ->image()
                            ->disk('public')
                            ->directory('slides')
                            ->visibility('public')
                            ->required()
                            ->columnSpanFull(),
                        Grid::make(4)->schema([
                            DatePicker::make('start_date')
                                ->label(__('Start Date')),
                            DatePicker::make('end_date')
                                ->label(__('End Date')),
                            TextInput::make('sort_order')
                                ->label(__('Order'))
                                ->numeric()
                                ->default(0),
                            Toggle::make('is_active')
                                ->label(__('Active'))
                                ->default(true),
                        ]),
                    ]),
            ]);
    }
}
