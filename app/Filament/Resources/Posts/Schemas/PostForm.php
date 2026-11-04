<?php

namespace App\Filament\Resources\Posts\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Group;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class PostForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Grid::make(3)->schema([
                    Group::make([
                        Section::make(__('Article Content'))
                            ->schema([
                                TextInput::make('title')
                                    ->label(__('Title'))
                                    ->required()
                                    ->maxLength(255)
                                    ->live(onBlur: true)
                                    ->afterStateUpdated(fn (Set $set, ?string $state) => $set('slug', Str::slug($state ?? ''))),
                                TextInput::make('slug')
                                    ->label(__('Slug'))
                                    ->required()
                                    ->maxLength(255)
                                    ->unique(ignoreRecord: true),
                                Textarea::make('summary')
                                    ->label(__('Summary'))
                                    ->rows(3),
                                RichEditor::make('content')
                                    ->label(__('Article Content'))
                                    ->fileAttachmentsDisk('public')
                                    ->fileAttachmentsDirectory('posts/attachments')
                                    ->fileAttachmentsVisibility('public')
                                    ->columnSpanFull(),
                            ]),
                    ])->columnSpan(2),

                    Group::make([
                        Section::make(__('Publication & Category'))
                            ->schema([
                                Hidden::make('user_id')
                                    ->default(fn () => Auth::id()),
                                Select::make('category_id')
                                    ->label(__('Category'))
                                    ->relationship('category', 'name')
                                    ->searchable()
                                    ->preload()
                                    ->required(),
                                Select::make('status')
                                    ->label(__('Status'))
                                    ->options([
                                        'draft' => __('Draft'),
                                        'published' => __('Published'),
                                        'archived' => __('Archived'),
                                    ])
                                    ->default('draft')
                                    ->required(),
                                DateTimePicker::make('published_at')
                                    ->label(__('Publication Date'))
                                    ->default(now()),
                                Toggle::make('is_featured')
                                    ->label(__('Featured Article'))
                                    ->default(false),
                            ]),

                        Section::make(__('Main Image'))
                            ->schema([
                                FileUpload::make('image')
                                    ->label(__('Cover Image'))
                                    ->image()
                                    ->disk('public')
                                    ->directory('posts/images')
                                    ->visibility('public'),
                            ]),
                    ])->columnSpan(1),
                ]),
            ]);
    }
}
