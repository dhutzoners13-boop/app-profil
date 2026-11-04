<?php

namespace App\Filament\Resources\Settings\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class SettingsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('group')
                    ->label(__('Group'))
                    ->badge()
                    ->color('info')
                    ->sortable(),
                TextColumn::make('key')
                    ->label(__('Key'))
                    ->searchable()
                    ->sortable(),
                TextColumn::make('value')
                    ->label(__('Value'))
                    ->limit(50),
                TextColumn::make('type')
                    ->label(__('Type'))
                    ->badge()
                    ->color('gray'),
                TextColumn::make('updated_at')
                    ->label(__('Last Updated'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->defaultSort('group', 'asc')
            ->filters([
                SelectFilter::make('group')
                    ->label(__('Group'))
                    ->options([
                        'general' => __('General'),
                        'contact' => __('Contact'),
                        'social' => __('Social Media'),
                        'api' => __('API'),
                    ]),
            ])
            ->recordActions([
                EditAction::make(),
                DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
