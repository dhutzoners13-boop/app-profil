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
use Illuminate\Support\Facades\Auth;

class AnswersRelationManager extends RelationManager
{
    protected static string $relationship = 'answers';

    protected static ?string $title = 'Jawaban Resmi';

    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Hidden::make('user_id')
                    ->default(fn () => Auth::id()),
                RichEditor::make('body')
                    ->label('Isi Tanggapan / Jawaban')
                    ->required()
                    ->columnSpanFull(),
                Select::make('status')
                    ->label('Status')
                    ->options([
                        'draft' => 'Draft',
                        'published' => 'Dipublikasikan',
                        'rejected' => 'Ditolak',
                    ])
                    ->default('published')
                    ->required(),
                Toggle::make('is_published')
                    ->label('Tampilkan ke Publik')
                    ->default(true),
                DateTimePicker::make('answered_at')
                    ->label('Waktu Menjawab')
                    ->default(now()),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('id')
            ->columns([
                TextColumn::make('user.name')
                    ->label('Petugas Penjawab')
                    ->searchable(),
                TextColumn::make('body')
                    ->label('Jawaban')
                    ->html()
                    ->limit(60),
                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->colors([
                        'warning' => 'draft',
                        'success' => 'published',
                        'danger' => 'rejected',
                    ]),
                IconColumn::make('is_published')
                    ->label('Publik')
                    ->boolean(),
                TextColumn::make('answered_at')
                    ->label('Dijawab Pada')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->headerActions([
                CreateAction::make()
                    ->label('Beri Jawaban')
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
