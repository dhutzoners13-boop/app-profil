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
                Section::make(__('Configuration Settings'))
                    ->schema([
                        Grid::make(3)->schema([
                            Select::make('group')
                                ->label(__('Setting Group'))
                                ->options([
                                    'general' => __('General (Institution Profile)'),
                                    'contact' => __('Contact & Address'),
                                    'social' => __('Social Media'),
                                    'api' => __('Integration / API'),
                                ])
                                ->default('general')
                                ->required(),
                            TextInput::make('key')
                                ->label(__('Identity Key'))
                                ->required()
                                ->maxLength(255)
                                ->unique(ignoreRecord: true),
                            Select::make('type')
                                ->label(__('Value Type'))
                                ->options([
                                    'text' => __('Short Text'),
                                    'textarea' => __('Long Text'),
                                    'image' => __('Image URL / Path'),
                                    'boolean' => __('Boolean (Yes/No)'),
                                    'json' => __('JSON Format'),
                                ])
                                ->default('text')
                                ->required(),
                        ]),
                        Textarea::make('value')
                            ->label(__('Setting Value'))
                            ->rows(4)
                            ->columnSpanFull(),
                    ]),
            ]);
    }
}
