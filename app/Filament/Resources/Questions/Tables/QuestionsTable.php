<?php

namespace App\Filament\Resources\Questions\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class QuestionsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('created_at')
                    ->label(__('Date Received'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
                TextColumn::make('name')
                    ->label(__('Questioner Name'))
                    ->searchable()
                    ->sortable(),
                TextColumn::make('topic.name')
                    ->label(__('Topic'))
                    ->badge()
                    ->color('info')
                    ->sortable(),
                TextColumn::make('subject')
                    ->label(__('Subject'))
                    ->searchable()
                    ->limit(35),
                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->colors([
                        'warning' => 'pending',
                        'success' => 'answered',
                        'danger' => 'rejected',
                    ]),
                TextColumn::make('answers_count')
                    ->counts('answers')
                    ->label(__('Answers'))
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                SelectFilter::make('topic_id')
                    ->label(__('Topic'))
                    ->relationship('topic', 'name'),
                SelectFilter::make('status')
                    ->label(__('Status'))
                    ->options([
                        'pending' => __('Awaiting Response'),
                        'answered' => __('Answered'),
                        'rejected' => __('Rejected'),
                    ]),
            ])
            ->recordActions([
                EditAction::make()->label(__('Respond / Edit')),
                DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
