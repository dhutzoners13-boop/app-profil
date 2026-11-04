<?php

namespace App\Filament\Resources\Questions\RelationManagers;

use App\Models\QuestionAnswer;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\CreateAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Toggle;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class AnswersRelationManager extends RelationManager
{
    protected static string $relationship = 'answers';

    public static function getTitle(Model $ownerRecord, string $pageClass): string
    {
        return __('Official Answers');
    }

    public static function getModelLabel(): ?string
    {
        return __('Official Answer');
    }

    public static function getPluralModelLabel(): ?string
    {
        return __('Official Answers');
    }

    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Hidden::make('user_id')
                    ->default(fn () => Auth::id()),
                RichEditor::make('body')
                    ->label(__('Response / Answer Body'))
                    ->required()
                    ->columnSpanFull(),
                Select::make('status')
                    ->label(__('Status'))
                    ->options([
                        'draft' => __('Draft'),
                        'published' => __('Published'),
                        'rejected' => __('Rejected'),
                    ])
                    ->default('published')
                    ->required(),
                Toggle::make('is_published')
                    ->label(__('Show to Public'))
                    ->default(true),
                DateTimePicker::make('answered_at')
                    ->label(__('Answered At'))
                    ->default(now()),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('id')
            ->columns([
                TextColumn::make('user.name')
                    ->label(__('Responding Officer'))
                    ->searchable(),
                TextColumn::make('body')
                    ->label(__('Answer'))
                    ->html()
                    ->limit(60),
                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->colors([
                        'warning' => 'draft',
                        'success' => 'published',
                        'danger' => 'rejected',
                    ]),
                IconColumn::make('is_published')
                    ->label(__('Public'))
                    ->boolean(),
                TextColumn::make('answered_at')
                    ->label(__('Answered At'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->headerActions([
                CreateAction::make()
                    ->label(__('Provide Answer'))
                    ->after(function (QuestionAnswer $record) {
                        if ($record->is_published || $record->status === 'published') {
                            $record->question?->update(['status' => 'answered']);
                        }
                    }),
            ])
            ->recordActions([
                EditAction::make()
                    ->after(function (QuestionAnswer $record) {
                        if ($record->is_published || $record->status === 'published') {
                            $record->question?->update(['status' => 'answered']);
                        }
                    }),
                DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
