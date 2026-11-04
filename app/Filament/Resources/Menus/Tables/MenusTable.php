<?php

namespace App\Filament\Resources\Menus\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class MenusTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->label(__('Menu Name'))
                    ->searchable()
                    ->sortable(),
                TextColumn::make('location')
                    ->label(__('Location'))
                    ->badge()
                    ->colors([
                        'primary' => 'header',
                        'success' => 'sidebar',
                        'warning' => 'footer',
                    ]),
                TextColumn::make('items_count')
                    ->counts('items')
                    ->label(__('Total Links'))
                    ->sortable(),
                IconColumn::make('is_active')
                    ->label(__('Active'))
                    ->boolean(),
                TextColumn::make('updated_at')
                    ->label(__('Last Modified'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('location')
                    ->label(__('Location'))
                    ->options([
                        'header' => __('Header'),
                        'footer' => __('Footer'),
                        'sidebar' => __('Sidebar'),
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
